Return-Path: <linux-kernel-owner+w=401wt.eu-S965140AbXA3QLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965140AbXA3QLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 11:11:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965565AbXA3QLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 11:11:48 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:22401 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965140AbXA3QLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 11:11:48 -0500
Date: Tue, 30 Jan 2007 08:08:15 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Philippe Dhont  \(Sea-ro\)" <philippe.dhont@searo.be>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: init/Kconfig:263: can't open file "usr/Kconfig" ==> when trying
 to configure new kernel
Message-Id: <20070130080815.9b393ec3.randy.dunlap@oracle.com>
In-Reply-To: <EB998357DB660742877807C9BD7D251B9BD145@SRVR1.searo.local>
References: <EB998357DB660742877807C9BD7D251B9BD145@SRVR1.searo.local>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 14:49:46 +0100 Philippe Dhont  \(Sea-ro\) wrote:

> hello,
>  
> i have a 2.6.8.-3-686 etch debian system.
> i want to manually download and install a new kernel because of some
> errors when installing vmware for linux.
> so i downloaded the new kernel 2.6.19.2 and when i do a "make
> menuconfig", i get:
>  
> ca-phlinux:/usr/src/linux-2.6.19.2# make menuconfig
> scripts/kconfig/mconf arch/i386/Kconfig
> init/Kconfig:263: can't open file "usr/Kconfig"
> make[1]: *** [menuconfig] Error 1
> make: *** [menuconfig] Error 2
> ca-phlinux:/usr/src/linux-2.6.19.2# uname -a Linux ca-phlinux
> 2.6.18-3-686 #1 SMP Mon Dec 4 16:41:14 UTC 2006 i686 GNU/Linux
> ca-phlinux:/usr/src/linux-2.6.19.2#
>  
>  
> i already tried:
>  
> ca-phlinux:/usr/src/linux-2.6.19.2# make-kpkg clean exec make -f
> /usr/share/kernel-package/ruleset/minimal.mk clean
> /usr/share/kernel-package/ruleset/minimal.mk:53: No .config file found
> ====== making target minimal_clean [new prereqs: ]====== Cleaning.
> test ! -f .config || cp -pf .config config.precious test ! -e
> stamp-building || rm -f stamp-building test ! -f Makefile || \
>             make    ARCH=i386 distclean
> make[1]: Entering directory `/usr/src/linux-2.6.19.2'
> scripts/Makefile.clean:17: /usr/src/linux-2.6.19.2/sound/usb/Makefile:
> No such file or directory
> make[3]: *** No rule to make target
> `/usr/src/linux-2.6.19.2/sound/usb/Makefile'.  Stop.
> make[2]: *** [sound/usb] Error 2
> make[1]: *** [_clean_sound] Error 2
> make[1]: Leaving directory `/usr/src/linux-2.6.19.2'
> make: *** [minimal_clean] Error 2
>  
>  
> also:
>  
> ca-phlinux:/usr/src/linux-2.6.19.2# make mrproper
> scripts/Makefile.clean:17: /usr/src/linux-2.6.19.2/sound/usb/Makefile:
> No such file or directory
> make[2]: *** No rule to make target
> `/usr/src/linux-2.6.19.2/sound/usb/Makefile'.  Stop.
> make[1]: *** [sound/usb] Error 2
> make: *** [_clean_sound] Error 2

If you are really missing these files:
	usr/Kconfig
	sound/usb/Makefile
then something is wrong with your tree or your download.

---
~Randy
