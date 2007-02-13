Return-Path: <linux-kernel-owner+w=401wt.eu-S1750973AbXBMRTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750973AbXBMRTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 12:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbXBMRTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 12:19:38 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:17331 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbXBMRTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 12:19:37 -0500
Date: Tue, 13 Feb 2007 09:15:34 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dominic Newton <dominic.newton@in-2-technology.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Small problem with kernel 2.6.20 and make menuconfig
Message-Id: <20070213091534.e4a0882e.randy.dunlap@oracle.com>
In-Reply-To: <45D1823F.1040204@in-2-technology.co.uk>
References: <45D1823F.1040204@in-2-technology.co.uk>
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

On Tue, 13 Feb 2007 09:17:51 +0000 Dominic Newton wrote:

> Just a small issue with the latest kernel 2.6.20. When compiling make 
> menuconfig our ncurses library is not being detected. I currently use 
> 2.6.15 with no problem and comparing the 2 I found a script ( 
> scripts/kconfig/lxdialog/check-lxdialog.sh ) in the lxdialog directory 
> that checks for the ncurses lib and sets compiler flags. For some reason 
> it will not find the ncurses library and thus menuconfig will not 
> compile and run.
> 
> 
> 
> I have ncurses installed (and symlinked) in the usual locations (/lib, 
> /usr/lib, /usr/include). I tried compiling the stock kernel in various 
> locations ( /, /usr /usr/src ) - same problem every time. I fixed the 
> problem by editing the scripts/kconfig/Makefile line 88-89 to ignore the 
> script and set HOST_EXTRACFLAGS = -DCURSES_LOC="<ncurses.h>" and 
> HOST_LOADLIBES = -lncurses.
> 
> menuconfig runs perfectly now ! I'm hopeless at scripts which is why I 
> gave up trying to get check-lxdialog.sh to work properly - sorry...
> 
> Any queries please let me know,

What does this print?  (from top of linux source tree)

$ sh scripts/kconfig/lxdialog/check-lxdialog.sh -ccflags

and
$ sh scripts/kconfig/lxdialog/check-lxdialog.sh -ldflags gcc


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
