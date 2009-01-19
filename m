Return-Path: <linux-kernel-owner+w=401wt.eu-S1758305AbZASVPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758305AbZASVPm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZASVPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:15:31 -0500
Received: from hpsmtp-eml19.KPNXCHANGE.COM ([213.75.38.84]:30838 "EHLO
	hpsmtp-eml19.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753250AbZASVPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:15:30 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/6] DMI: Introduce dmi_first_match to make the interface more flexible
Date: Mon, 19 Jan 2009 22:15:24 +0100
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jeff@garzik.org>, tj@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20081104062734.GA4420@havoc.gtf.org> <200901192053.50831.rjw@sisk.pl> <200901192055.51108.rjw@sisk.pl>
In-Reply-To: <200901192055.51108.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901192215.27650.elendil@planet.nl>
X-OriginalArrivalTime: 19 Jan 2009 21:15:28.0060 (UTC) FILETIME=[0D5DFFC0:01C97A7B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 January 2009, Rafael J. Wysocki wrote:
> +const struct dmi_system_id *dmi_first_match(const struct dmi_system_id
> *list)
> +{ 
> +       const struct dmi_system_id *d;
> +
> +       for (d = list; d->ident; d++)
> +               if (dmi_matches(d))
> +                       return d;
> +
> +       return NULL;
> +}
> +EXPORT_SYMBOL(dmi_first_match);

I did indeed have an older version of the patches (before you split them 
out) and that was missing the "const" in the first quoted line, so that 
explains the warning I had.

If I compare the version I've been running with the past months and this 
series I see only minor changes and I don't expect any problems from 
them. If I notice anything I'll let you know. No news is good news :-)

Thanks,
FJP
