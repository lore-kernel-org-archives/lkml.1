Return-Path: <linux-kernel-owner+w=401wt.eu-S932285AbXK2QUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285AbXK2QUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762724AbXK2QTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:19:50 -0500
Received: from smtp.witbe.net ([81.88.96.48]:59306 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762388AbXK2QTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:19:48 -0500
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Nov 2007 11:19:47 EST
Date: Thu, 29 Nov 2007 17:11:42 +0100
From: Paul Rolland (=?UTF-8?Q?=E3=83=9D=E3=83=BC=E3=83=AB=E3=83=BB?=
	=?UTF-8?Q?=E3=83=AD=E3=83=A9=E3=83=B3?=) <rol@witbe.net>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: rol@witbe.net
Subject: constant_tsc and TSC unstable
Message-ID: <20071129171142.56c7890a@tux.DEF.witbe.net>
Organization: Witbe.net
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've a machine with a Core2Duo CPU. /proc/cpuinfo reports the flag
constant_tsc, but at boot time, I have the log :

...
Total of 2 processors activated (6919.15 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 3978592228 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to: check_tsc_sync_source failed.
Brought up 2 CPUs
...

This machine is running 2.6.23.1-21.fc7. I know I should report to Fedora,
but I was wondering if this is a bug or a feature ;)

Regards,
Paul
