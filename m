Return-Path: <linux-kernel-owner+w=401wt.eu-S933352AbZARKU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352AbZARKU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 05:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762975AbZARKUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 05:20:14 -0500
Received: from hpsmtp-eml16.KPNXCHANGE.COM ([213.75.38.116]:2994 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762949AbZARKUM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 05:20:12 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [git patches] libata hibernation fixes
Date: Sun, 18 Jan 2009 11:20:07 +0100
User-Agent: KMail/1.9.9
Cc: jeff@garzik.org, tj@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20081104062734.GA4420@havoc.gtf.org> <495D7DC9.8070101@kernel.org> <49698739.6010003@garzik.org> <49698739.6010003@garzik.org> <200901111343.49901.rjw@sisk.pl>
In-reply-To: <200901111343.49901.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901181120.08992.elendil@planet.nl>
X-OriginalArrivalTime: 18 Jan 2009 10:20:09.0669 (UTC) FILETIME=[575DE750:01C97956]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> There is a name conflict with a change applied after this patchset had
> been created.  The appended patch fixes it for me.
[...]
> @@ -483,7 +483,7 @@ const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list)
>         const struct dmi_system_id *d; 
> 
>         for (d = list; d->ident; d++)
> -               if (dmi_match(d))
> +               if (dmi_matches(d))
>                         return d;

I get two warnings when compiling your patch with this correction on top:
drivers/firmware/dmi_scan.c: In function ‘dmi_first_match’:
drivers/firmware/dmi_scan.c:488: warning: return discards qualifiers from pointer target type
drivers/firmware/dmi_scan.c:483: warning: unused variable ‘i’

The second is trivial, but the first is beyond me :-/

Cheers,
FJP
