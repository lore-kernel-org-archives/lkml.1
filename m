Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbXLKPiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbXLKPiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbXLKPiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:38:11 -0500
Received: from smtp.witbe.net ([81.88.96.48]:46068 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbXLKPiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:38:09 -0500
Date: Tue, 11 Dec 2007 16:37:06 +0100
From: Paul Rolland <rol@as2917.net>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: David Newall <david@davidnewall.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
Message-ID: <20071211163706.2dc82275@tux.DEF.witbe.net>
In-Reply-To: <475EACB8.7080608@keyaccess.nl>
References: <475879CD.9080006@reed.com>
	<p733auekcly.fsf@bingen.suse.de>
	<20071207160439.71b7f46a@the-village.bc.nu>
	<20071209125458.GB4381@ucw.cz>
	<20071209165908.GA15910@one.firstfloor.org>
	<20071209212513.GC24284@elf.ucw.cz>
	<475CBDD7.5050602@keyaccess.nl>
	<m3bq8y23de.fsf@maximus.localdomain>
	<475DE37F.20706@davidnewall.com>
	<475DE6F4.80702@zytor.com>
	<475DEB23.1000304@davidnewall.com>
	<20071211084059.3d03e11d@tux.DEF.witbe.net>
	<475E5D4B.8020101@keyaccess.nl>
	<475E7DC2.4060509@davidnewall.com>
	<475E8D91.20201@keyaccess.nl>
	<20071211143224.15900995@tux.DEF.witbe.net>
	<475E9B9B.2050709@keyaccess.nl>
	<475EACB8.7080608@keyaccess.nl>
Organization: AS2917.net
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, 11 Dec 2007 16:28:56 +0100
Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 11-12-07 15:15, Rene Herman wrote:
> 
> > On 11-12-07 14:32, Paul Rolland wrote:
> > 
> This might be a bit more constant, I suppose. This serialises with cpuid. 
> Don't see a difference locally, but perhaps you do.
Well, yes, at least on the PIII and the Opteron... Core2 is still changing
a lot...

> On a Duron 1300 with an actual ISA bus, "out" is between 1300 and 1600 for 
> me and "in" between 1200 and 1500 with a few flukes above that which will I 
> suppose be caused by the bus (ISA _or_ PCI) being momentarily busy or some 
> such...
The results :

Core 2Duo 1.73 GHz :
[root@tux tmp]# ./in2
out: 2777
in : 2519
[root@tux tmp]# ./in2
out: 2440
in : 2391
[root@tux tmp]# ./in2
out: 2460
in : 2388

Pentium III :
[root@www-dev /tmp]# ./in2
out: 746
in : 747
[root@www-dev /tmp]# ./in2
out: 746
in : 747
[root@www-dev /tmp]# ./in2
out: 746
in : 745

AMD Opteron 150 :
-bash-3.1# ./in2
out: 4846
in : 4845
-bash-3.1# ./in2
out: 4846
in : 4846
-bash-3.1# ./in2
out: 4846
in : 4845

Paul
