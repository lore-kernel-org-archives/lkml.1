Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbZEPIqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbZEPIqA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 04:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbZEPIpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 04:45:51 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:59794 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZEPIpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 04:45:50 -0400
Date: Sat, 16 May 2009 10:48:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>,
       Nico Schottelius <nico-linux-20090330@schottelius.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: setlocalversion bug [Was: Linux 2.6.30-rc6]
Message-ID: <20090516084801.GA16044@uranus.ravnborg.org>
References: <alpine.LFD.2.01.0905152120140.3301@localhost.localdomain> <4A0E62D4.5080004@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0E62D4.5080004@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 02:53:08AM -0400, Jeff Garzik wrote:
> 
> Strange version numbering....   x86-64/Fedora 10/2.6.30-rc6 with no 
> local modifications or 'localversion' file, built straight from git:
> 
> $ make -s oldconfig && make -sj17
> $ sudo make modules_install && sudo make install
> ...
>   INSTALL /lib/firmware/edgeport/down2.fw
>   INSTALL /lib/firmware/whiteheat_loader.fw
>   INSTALL /lib/firmware/whiteheat.fw
>   DEPMOD  2.6.30-rc6-00000-rc6
> sh /spare/repo/linux-2.6/arch/x86/boot/install.sh 2.6.30-rc6-00000-rc6 
> arch/x86/boot/bzImage \
> 		System.map "/boot"
> 
> 
> 
> "2.6.30-rc6-00000-rc6" seems like something is broken, as building a 
> released version from git always gave me a proper "2.6.30-rc5"-style 
> version, as expected.

Hi Nico.

This looks like something introduced by: 
a182ad3d0f858f50bb719a48bb35a013e12366c5
("kbuild: fix scripts/setlocalversion with git")

Can you take a look at this.

	Sam
