Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbZASUBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbZASUBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZASUAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:00:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39378 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbZASUAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:00:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH 0/6] Hibernation/poweroff quirks (was: Re: [git patches] libata hibernation fixes)
Date: Mon, 19 Jan 2009 20:53:49 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-tst; KDE/4.1.3; x86_64; ; )
Cc: Frans Pop <elendil@planet.nl>, tj@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20081104062734.GA4420@havoc.gtf.org> <200901182125.04060.rjw@sisk.pl> <49739371.5030107@garzik.org>
In-Reply-To: <49739371.5030107@garzik.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901192053.50831.rjw@sisk.pl>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 January 2009, Jeff Garzik wrote:
> Rafael J. Wysocki wrote:
> > On Sunday 18 January 2009, Frans Pop wrote:
> >> Rafael J. Wysocki wrote:
> >>> There is a name conflict with a change applied after this patchset had
> >>> been created.  The appended patch fixes it for me.
> >> [...]
> >>> @@ -483,7 +483,7 @@ const struct dmi_system_id *dmi_first_match(const struct dmi_system_id *list)
> >>>         const struct dmi_system_id *d; 
> >>>
> >>>         for (d = list; d->ident; d++)
> >>> -               if (dmi_match(d))
> >>> +               if (dmi_matches(d))
> >>>                         return d;
> >> I get two warnings when compiling your patch with this correction on top:
> > 
> > Hm, there were more patches than one, so I'm not sure.  When I apply all of
> > them, I don't see these error, but perhaps I should resend the entire series.
> > Will do tomorrow.
> 
> That would be useful...  I was planning to regenerate the series, but 
> this would save time.

The rebased series follows.

Thanks,
Rafael

