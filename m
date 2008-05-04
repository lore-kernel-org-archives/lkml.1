Return-Path: <linux-kernel-owner+w=401wt.eu-S1756556AbYEDL31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556AbYEDL31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 07:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbYEDL3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 07:29:20 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59776 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbYEDL3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 07:29:19 -0400
Date: Sun, 4 May 2008 13:29:54 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: build issue #479 for v2.6.26-rc1-6-gafa26be :redefinition of 'sysfs_update_group'
Message-ID: <20080504112954.GB18379@uranus.ravnborg.org>
References: <200805041053.43284.toralf.foerster@gmx.de> <20080504104127.GD17276@uranus.ravnborg.org> <200805041256.52514.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200805041256.52514.toralf.foerster@gmx.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 12:56:48PM +0200, Toralf Förster wrote:
> At Sunday 04 May 2008 12:41:27 Sam Ravnborg wrote :
> > On Sun, May 04, 2008 at 10:53:40AM +0200, Toralf Förster wrote:
> > > include/linux/sysfs.h:195: error: previous definition of 'sysfs_update_group' was here
> > > make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> > > make: *** [prepare0] Error 2
> > > 
> > > The build was made with :
> > > $> make mrproper && make randconfig && make
> > 
> > Why do you need the "make mrproper" in the first place?
> > 
> > kbuild should build what is needed when the config changes.
> > 
> > 	Sam
> > 
> 
> Hhm,
> 
> when I wrote the script one or two years ago for automated build tests I got
> sometimes false positives w/o "make mrproper" - IIRC.
> Maybe it's time to remove it to see whether kbuild works as expected  ?

Appreciated - thanks Toralf.

	Sam
