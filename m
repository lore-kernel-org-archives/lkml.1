Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZARUZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZARUZl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 15:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZARUZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 15:25:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58917 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbZARUZ2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 15:25:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [git patches] libata hibernation fixes
Date: Sun, 18 Jan 2009 21:25:03 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: jeff@garzik.org, tj@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20081104062734.GA4420@havoc.gtf.org> <200901111343.49901.rjw@sisk.pl> <200901181120.08992.elendil@planet.nl>
In-Reply-To: <200901181120.08992.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901182125.04060.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 January 2009, Frans Pop wrote:
> Rafael J. Wysocki wrote:
> > There is a name conflict with a change applied after this patchset had
> > been created.  The appended patch fixes it for me.
> [...]
> > @@ -483,7 +483,7 @@ const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list)
> >         const struct dmi_system_id *d; 
> > 
> >         for (d = list; d->ident; d++)
> > -               if (dmi_match(d))
> > +               if (dmi_matches(d))
> >                         return d;
> 
> I get two warnings when compiling your patch with this correction on top:

Hm, there were more patches than one, so I'm not sure.  When I apply all of
them, I don't see these error, but perhaps I should resend the entire series.
Will do tomorrow.

> drivers/firmware/dmi_scan.c: In function ‘dmi_first_match’:
> drivers/firmware/dmi_scan.c:488: warning: return discards qualifiers from pointer target type
> drivers/firmware/dmi_scan.c:483: warning: unused variable ‘i’
> 
> The second is trivial, but the first is beyond me :-/

Thanks,
Rafael
