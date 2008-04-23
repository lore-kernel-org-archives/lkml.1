Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbYDWHjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbYDWHjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 03:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYDWHjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 03:39:40 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:33736 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbYDWHjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 03:39:39 -0400
Date: Wed, 23 Apr 2008 09:39:36 +0200
Message-Id: <250404281@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: werner@copaya.yi.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: EDD problem -- regression -- crash on booting by probing EDD
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/9ceXbF3b3cAOdbudGR3LQhABVqeEyCbOOx1yljwsiiGPqn
 0rM9qLBKQBQco7hpjnJagn1Dtn+a5MrQ3fRG0NWQm5UDsaC4FQ=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi !

>As I tested yesterday extensively, the problem wasn't present at 2.6.24-rc5-git6 (SYS \
>Linux 0.17 install DVD) nor at 2.6.24-rc6-git2 (SYS 0.19) ,  but at 2.6.24-rc6-git8 \
>(SYS 0.20-rc1 and 0.20-rc2) and 2.6.25 (0.21-r3).

any chance to git-bisect that further, to find the single commit which broke your kernel?

regards
roland



List:       linux-kernel
Subject:    Re: EDD problem -- regression -- crash on booting by probing EDD
From:       "werner" <werner () copaya ! yi ! org>
Date:       2008-04-23 0:20:44
Message-ID: 1208910044.20701 () copaya ! yi ! org
[Download message RAW]

As I tested yesterday extensively, the problem wasn't present at 2.6.24-rc5-git6 (SYS \
Linux 0.17 install DVD) nor at 2.6.24-rc6-git2 (SYS 0.19) ,  but at 2.6.24-rc6-git8 \
(SYS 0.20-rc1 and 0.20-rc2) and 2.6.25 (0.21-r3).

The whole compiled packages of these kernels still are at copaya.yi.org/tgz , but I \
extracted  the important parts, see enclosed here.    The .tar.bz2 file contains  the \
config  and the protocoll of the compilation (inclusive warning / error messages). 

As you can see, the diff between the config of 2.6.24-rc6-git2 and -git8 is nothing.  \
That means: THE ERROR ENTERED INTO THE KERNEL BETWEEN THESE TWO GITs !!      

You may also analyze the error/warning messages. Please observe that the error \
message just at the beginning was already subject of another reclamation mine \
together with another person, and seems to have be corrected.

I inform still about the following:    As I make many experients and also install \
Linux often for firnds and neighbours, I see steady-steady some kernel errors, but \
have normally no time to track them, in the house of the persons.  That error here, I \
saw already several times, and never it helped the edd=off option.    Yesterday it \
happened that a friend brought a laptop (ACER Aspire 7004WSMi) to me, after he was \
unsuccessfull to install  SYS 0.21-r3 dvd with 2.6.25-rc7 . Then I tracked that \
problem during about 5 hours, inclusively trying a lot of different kernel options.  \
edd=off don't work at all, with no of the affected kernels.  With 2.6.24-rc6-git2 and \
earlier kernels the problem didnt appear, even without edd=off option, and with the \
later kernels it appears, even with edd=off .    With pci=off , also the recent \
kernels boots -- but this is useless because the system don't find any hard disk.  \
acpi=off or hwprobe=off have no influence on that problem.

Pls search that error and repair it !
**********  YOU SHOULD MAKE AN EXTRA KERNEL OPTION, WHAT IGNORES THE HARDWARE AND \
CONTINUES TO BOOT, like pci=off,  BUT WHAT DETECTS CD ROMS, HARD DISKS SATA / IDE / \
RAID , AND WHAT PERMITS TO USE THE COMPUTER NORMALLY AT LEAST IN VESA-FB OR FBDEV \
MODE !!!!! *************

As there has no other solution, I released last night SYS 0.21-r4 DVD , what contains \
both, the 2.6.25 , and alternatively 2.6.24-rc6-git2 , so that people can use them \
computer anyway / anyhow :    ftp://ftp5.gwdg.de/pub/linux/install/sys/  

I can put the suggested debug, generally, in the kernel command line of my SYS \
install DVD. However, the person gone with his laptop so that at the moment I cannot \
test it; I have to wait if the same problem occurs on another computer.  


_________________________________________________________________________
In 5 Schritten zur eigenen Homepage. Jetzt Domain sichern und gestalten! 
Nur 3,99 EUR/Monat! http://www.maildomain.web.de/?mc=021114

