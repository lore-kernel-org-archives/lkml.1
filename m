Return-Path: <linux-kernel-owner+w=401wt.eu-S934594AbXEHRgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594AbXEHRgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 13:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934427AbXEHRgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 13:36:24 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:7538 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934384AbXEHRgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 13:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kEnSs3G4CkJADMzLTCMOfRuYFkJczgVjP8lwCeHHXlrR5hYXG6N+GXxi+b4LgLqzPQF/AoeHrIRtWeIw6c1xgqFmUJGS8co+Hx4ocfEzHkbe5fSHVvZj+KK9MGA3j0BzRXBh3FCNCa/2UFVE/R0ueWogwljZGWGOSbJ1ioVOQng=
Message-ID: <55f6199c0705081036w60611d0cr33d51bcaef4782cd@mail.gmail.com>
Date: Tue, 8 May 2007 13:36:21 -0400
From: Disconnect <dc.disconnect@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <20070507203859.GB18400@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <Pine.LNX.4.63.0705061909290.19118@qynat.qvtvafvgr.pbz>
	 <20070507124818.GA18209@elf.ucw.cz>
	 <200705071452.21969.oneukum@suse.de>
	 <Pine.LNX.4.64.0705070736010.18013@asgard.lang.hm>
	 <20070507195142.GC3981@ucw.cz>
	 <Pine.LNX.4.64.0705071250460.21621@asgard.lang.hm>
	 <20070507203859.GB18400@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We used it (with great success) to replace bad UPSs on single-PSU
database servers under (light) load. No need for scheduled downtime,
etc.

The whole point of hibernation (or suspend to disk, or whatever you
call it) is that the system goes to a zero-power state and then can be
brought back to its original state. Closing in-progress network
connections has nothing to do with pausing a machine any more than
setting IM clients to 'away' would, or locking an X session. That sort
of side-effect needs to be handled outside the core of "put state out
to disk and read it back".

On 5/7/07, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> > I don't dispute that it sometimes works today.
> >
> > what I dispute is that makeing it work should be a contraint on a cleaner
> > design that happens to cause tcp connections to fail on suspend-to-disk
> > (hibernate).
> >
> > if you are dong suspend-to-disk for such a short period that TCP
> > connections are able to recover (typically <15 min for most firewalls, in
> > some cases <2 min for connections with keep-alive) is it really
> > worth it?
>
> People were using swsusp to move server from one room to another.
>                                                                         Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
