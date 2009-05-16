Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbZEPXKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbZEPXKW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 19:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbZEPXKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 19:10:04 -0400
Received: from mail.crca.org.au ([67.207.131.56]:46798 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbZEPXKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 19:10:02 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
In-Reply-To: <20090514091616.GB6417@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <200905090046.21282.rjw@sisk.pl> <20090509132711.GD10859@elf.ucw.cz>
	 <200905092132.11138.rjw@sisk.pl>  <20090514091616.GB6417@elf.ucw.cz>
Content-Type: text/plain
Date: Sun, 17 May 2009 09:11:23 +1000
Message-Id: <1242515483.17419.71.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

(Starting to catch up after a week away)

On Thu, 2009-05-14 at 11:16 +0200, Pavel Machek wrote:
> Hi!
> 
> > > > > And we have different ideas about how things should be done. Userspace
> > > > > vs kernel space. Providing tuning knobs vs not. And so on.
> > > > 
> > > > This isn't _that_ important.  Actually, I'm not against an entirely in-kernel
> > > > solution, as there are some clear benefits of doing it this way.  We only
> > > > need to be careful enough not to break the existing setups.
> > > 
> > > Would you elaborate?
> > 
> > One benefit is that we need not anything in the initrd for hibernation to work.
> > Another one is that we can get superior performance, for obvious reasons
> > (less copying of data, faster I/O).   Yet another is simpler configuration and
> > no need to maintain a separate set of user space tools.  I probably could
> > find more.
> >  
> > > I would really hate to put progressbar painting into kernel; and if
> > > that's in userspace, we can do compression/encryption there too as
> > > well....
> > 
> > That's correct, we can.  But since we have LZO in the kernel now, we can use
> > it for compression just as well, can't we?
> 
> Yes, but we do not have progressbar painting in the kernel -- yet --
> so users will still need initrd etc.

Who does?

> Yes, we can move LZO into kernel pretty cheaply, and it will have
> minor benefit of slightly faster reguler swsusp, but...

LZO is already in the kernel (a cryptoapi module). The result won't be
slightly faster - it will be (assuming the CPU is fast enough) slightly
better than double the speed, on average.

Regards,

Nigel

