Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbZEITcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbZEITcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 15:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZEITcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 15:32:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52076 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbZEITcC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 15:32:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Date: Sat, 9 May 2009 21:32:10 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4-rjw; KDE/4.2.2; x86_64; ; )
Cc: nigel@tuxonice.net, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905090046.21282.rjw@sisk.pl> <20090509132711.GD10859@elf.ucw.cz>
In-Reply-To: <20090509132711.GD10859@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905092132.11138.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 May 2009, Pavel Machek wrote:
> Hi!
> 
> > > And we have different ideas about how things should be done. Userspace
> > > vs kernel space. Providing tuning knobs vs not. And so on.
> > 
> > This isn't _that_ important.  Actually, I'm not against an entirely in-kernel
> > solution, as there are some clear benefits of doing it this way.  We only
> > need to be careful enough not to break the existing setups.
> 
> Would you elaborate?

One benefit is that we need not anything in the initrd for hibernation to work.
Another one is that we can get superior performance, for obvious reasons
(less copying of data, faster I/O).   Yet another is simpler configuration and
no need to maintain a separate set of user space tools.  I probably could
find more.
 
> I would really hate to put progressbar painting into kernel; and if
> that's in userspace, we can do compression/encryption there too as
> well....

That's correct, we can.  But since we have LZO in the kernel now, we can use
it for compression just as well, can't we?

Thanks,
Rafael
