Return-Path: <linux-kernel-owner+w=401wt.eu-S1751216AbXBMJXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbXBMJXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 04:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbXBMJXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 04:23:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:52327 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbXBMJXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 04:23:01 -0500
Message-ID: <45D1823F.1040204@in-2-technology.co.uk>
Date: Tue, 13 Feb 2007 09:17:51 +0000
From: Dominic Newton <dominic.newton@in-2-technology.co.uk>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Small problem with kernel 2.6.20 and make menuconfig
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:16f7ebfda4f16b43efce7857b01e6899
X-Provags-ID2: V01U2FsdGVkX1+DeliWHl5XvKEZAGRO/mLR+d2CPC9454q9515cmoZrSZ1Wo5X9AbaGA140NAH2oeVbVw/yUv8J5LoYuEYKI5ZbyrMV36jrmy1j1B9nTV6swTPc4DBvJN/zfypIfe8Gk8LOEbzJrokD3Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Just a small issue with the latest kernel 2.6.20. When compiling make 
menuconfig our ncurses library is not being detected. I currently use 
2.6.15 with no problem and comparing the 2 I found a script ( 
scripts/kconfig/lxdialog/check-lxdialog.sh ) in the lxdialog directory 
that checks for the ncurses lib and sets compiler flags. For some reason 
it will not find the ncurses library and thus menuconfig will not 
compile and run.



I have ncurses installed (and symlinked) in the usual locations (/lib, 
/usr/lib, /usr/include). I tried compiling the stock kernel in various 
locations ( /, /usr /usr/src ) - same problem every time. I fixed the 
problem by editing the scripts/kconfig/Makefile line 88-89 to ignore the 
script and set HOST_EXTRACFLAGS = -DCURSES_LOC="<ncurses.h>" and 
HOST_LOADLIBES = -lncurses.

menuconfig runs perfectly now ! I'm hopeless at scripts which is why I 
gave up trying to get check-lxdialog.sh to work properly - sorry...

Any queries please let me know,


Regards



Dominic Newton
