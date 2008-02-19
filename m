Return-Path: <linux-kernel-owner+w=401wt.eu-S1762847AbYBSIuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762847AbYBSIuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYBSIub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:50:31 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:48510 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbYBSIua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:50:30 -0500
Date: Tue, 19 Feb 2008 09:50:33 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Greg KH <greg@kroah.com>, kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
Message-ID: <20080219085033.GA1775@uranus.ravnborg.org>
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73zltyxy9q.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 01:08:33PM +0100, Andi Kleen wrote:
> Greg KH <greg@kroah.com> writes:
> >
> > If Jeff does that, I still can't drop those PCI functions from the PCI
> > core, which I desperatly want to do as they do not play nice with modern
> > systems (meaning hotplug...).
> >
> > So either way, I think his patches should go in.
> 
> Merging essentially untested patches does not seem like a good strategy.
> And there is definitely still a large ISDN user base too.
Only issue seems that this large ISDN user base is not very active
in respect to Linux driver development.
Or at least not judging from the missing responses to their
mailing list and the limited traffic on said mailing list.

Reading the isdn4linux it is obvious that the way forward are the
mISDN code base so maybe that explains why noone steps up and 
test the patches of Jeff's.

If noone in the isdn community step up and take some responsibility
for the current isdn drivers in Linux then we should just delete them.
If anyone cares they can always be forwardported or even better we can 
integrate the much more flexible mISDN solution.

> My personal guess is that there are far more ISDN users than (non cardbus)
> PCI/PCI-e hotplug users.

My guess is that very very few uses ISDN in combination with a recent kernel.
Hmm, wonder if it is more fun hacking isdn drivers than kbuild
stuff and section mismatches ;-)

	Sam
