Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZGTUfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZGTUfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZGTUfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:35:14 -0400
Received: from main.gmane.org ([80.91.229.2]:46130 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbZGTUfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:35:13 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Marcel Beister <marcel@mcbeister.de>
Subject: Re: Linux 2.6.30.2: does not boot
Date: Mon, 20 Jul 2009 20:29:25 +0000 (UTC)
Message-ID: <loom.20090720T202338-533@post.gmane.org>
References: <20090720040813.GC11940@kroah.com> <200907201613.22483.wolfgang.walter@stwm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 92.194.36.72 (Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1) Gecko/20090707 Iceweasel/3.5 (Debian-3.5-1))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Built 2.6.30.2 but it hangs when booting immediately after the message:
> 
> Booting the kernel.
> 
> I built it with gcc version 4.3.3 on debian/sid and used exactly the 
> same .config as I used with 2.6.32.1  (ok, + "DEFAULT_MMAP_MIN_ADDR 4096" 
> which didn't exist before).
> 
> Regards,


Hi,

I had the same problem this weekend and I also checked various configurations,
but actually this is a problem with binutils_2.19.51.20090714-1.

I found the following bug report for binutils which exactly described my problem:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=537389

I downgraded binutils to the testing version (binutils_2.19.1-1) and the kernel
booted without any problems. I did this for 2 other machines and they all
rebooted with the sid version and they all booted fine with the testing version.

--
 Marcel

