Return-Path: <linux-kernel-owner+w=401wt.eu-S1750711AbXIPKrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750711AbXIPKrl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 06:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbXIPKrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 06:47:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:20413 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbXIPKra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 06:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qcqHG0SboxpNkmlR6XO7TqpUyMpeKa1EyDh3bksJz7QmCtscbaIUW3pf0iJzzm5VIdTdA4Fw7OQ6lr9l4EQITN8CrjJZet9d8N6Y6+CtUvwZlaPxX8W0fJpJJpfChTwvlOnxY3DHeTrF3QGNRhXcmtVkJ+dm2J0DDik84yZ/VCU=
Message-ID: <a781481a0709160347t647fab9fs505dd053f3fe203d@mail.gmail.com>
Date: Sun, 16 Sep 2007 16:17:29 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Timo Lindemann" <tlindemann@arcor.de>
Subject: Re: PROBLEM: kernel hang in ohci init
Cc: linux-kernel@vger.kernel.org, "David Brownell" <david-b@pacbell.net>
In-Reply-To: <a781481a0709160343l530b067bg55a4679e1cf864ab@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4695EC25.6050003@arcor.de>
	 <a781481a0707122015q48fd8a06m5d0e54b109708757@mail.gmail.com>
	 <200707122040.36800.david-b@pacbell.net> <4699F9CB.5010407@arcor.de>
	 <a781481a0707150418o35e4d60fs59cba3f835ebef67@mail.gmail.com>
	 <a781481a0707150429y22b8b10bv413f5f6ba498d3e4@mail.gmail.com>
	 <469A09C9.6000608@arcor.de>
	 <a781481a0709160343l530b067bg55a4679e1cf864ab@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/16/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> Hi Timo,
>
>
> On 7/15/07, Timo Lindemann <tlindemann@arcor.de> wrote:
> > To sum this up:
> >
> > the userspace 2.6.20.6 (the "good" kernel) and 2.6.22 (the "bad" kernel)
> > were compiled in is exactly the same setup. I recompiled "good" to check
> > for that, earlier, but "good" also works then.
> >
> > "good" does not exhibit the printks I placed in the section (the same
> > ones I did for "bad"), making it plausible that the section is not
> > executed at all.
> >
> > dmesg is not captured to disk, netconsole and serial console also do not
> > work (they both did in the "good" kernel). Also, my keyboard does not
> > work with "bad" during that phase -- Magic SysRq is also not working then.
> >
> > I can try to hook up the laptop to an external monitor to capture some
> > more dmesg, and just shoot a photo, but I am right now trying to work
> > with git, as Satyam suggested.
>
> Any updates on this for us? Or did the kernel start booting magically again
> ca. 2.6.23-rc6? ;-)

Should again add that best would still be to simply git-bisect Linus' (mainline)
kernel tree between 2.6.20 (not 2.6.20.6) and 2.6.22 and just find the commit
after which your box stops booting ...


> Anyway, it appears the bug got introduced sometime between 2.6.20 and
> 2.6.22 so probably bugzilla becomes a better place to track this one. Could
> you open up a bug report (similar to your original post) there?
>
> Thanks,
>
> Satyam
>
