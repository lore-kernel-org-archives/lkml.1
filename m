Return-Path: <linux-kernel-owner+w=401wt.eu-S965463AbXA3OPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965463AbXA3OPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965468AbXA3OPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:15:38 -0500
Received: from mail.searo.be ([194.78.182.131]:3935 "EHLO server1.searo.be"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965463AbXA3OPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:15:37 -0500
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Jan 2007 09:15:36 EST
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5.6944.0
Subject: init/Kconfig:263: can't open file "usr/Kconfig" ==> when trying to configure new kernel
Date: Tue, 30 Jan 2007 14:49:46 +0100
Message-ID: <EB998357DB660742877807C9BD7D251B9BD145@SRVR1.searo.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: init/Kconfig:263: can't open file "usr/Kconfig" ==> when trying to configure new kernel
Thread-Index: AcdEdJmHthXjP6cJSMq6twQZ4flJ9QAANnAQ
From: "Philippe Dhont  \(Sea-ro\)" <philippe.dhont@searo.be>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



hello,
 
i have a 2.6.8.-3-686 etch debian system.
i want to manually download and install a new kernel because of some
errors when installing vmware for linux.
so i downloaded the new kernel 2.6.19.2 and when i do a "make
menuconfig", i get:
 
ca-phlinux:/usr/src/linux-2.6.19.2# make menuconfig
scripts/kconfig/mconf arch/i386/Kconfig
init/Kconfig:263: can't open file "usr/Kconfig"
make[1]: *** [menuconfig] Error 1
make: *** [menuconfig] Error 2
ca-phlinux:/usr/src/linux-2.6.19.2# uname -a Linux ca-phlinux
2.6.18-3-686 #1 SMP Mon Dec 4 16:41:14 UTC 2006 i686 GNU/Linux
ca-phlinux:/usr/src/linux-2.6.19.2#
 
 
i already tried:
 
ca-phlinux:/usr/src/linux-2.6.19.2# make-kpkg clean exec make -f
/usr/share/kernel-package/ruleset/minimal.mk clean
/usr/share/kernel-package/ruleset/minimal.mk:53: No .config file found
====== making target minimal_clean [new prereqs: ]====== Cleaning.
test ! -f .config || cp -pf .config config.precious test ! -e
stamp-building || rm -f stamp-building test ! -f Makefile || \
            make    ARCH=i386 distclean
make[1]: Entering directory `/usr/src/linux-2.6.19.2'
scripts/Makefile.clean:17: /usr/src/linux-2.6.19.2/sound/usb/Makefile:
No such file or directory
make[3]: *** No rule to make target
`/usr/src/linux-2.6.19.2/sound/usb/Makefile'.  Stop.
make[2]: *** [sound/usb] Error 2
make[1]: *** [_clean_sound] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.19.2'
make: *** [minimal_clean] Error 2
 
 
also:
 
ca-phlinux:/usr/src/linux-2.6.19.2# make mrproper
scripts/Makefile.clean:17: /usr/src/linux-2.6.19.2/sound/usb/Makefile:
No such file or directory
make[2]: *** No rule to make target
`/usr/src/linux-2.6.19.2/sound/usb/Makefile'.  Stop.
make[1]: *** [sound/usb] Error 2
make: *** [_clean_sound] Error 2

 
 
I really need to do this...
thanks.
greetz,
Philippe

