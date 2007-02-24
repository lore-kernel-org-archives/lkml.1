Return-Path: <linux-kernel-owner+w=401wt.eu-S933006AbXBXPZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006AbXBXPZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 10:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933007AbXBXPZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 10:25:25 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:45014 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933006AbXBXPZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 10:25:23 -0500
Date: Sat, 24 Feb 2007 16:23:45 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Walrond <andrew@walrond.org>
cc: Tomasz Chmielewski <mangoo@wpkg.org>, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: (Sparc64) 2.6.20 seems to ignore initramfs
In-Reply-To: <200702231547.24667.andrew@walrond.org>
Message-ID: <Pine.LNX.4.61.0702241622150.16527@yvahk01.tjqt.qr>
References: <200702231108.10185.andrew@walrond.org> <200702231446.20929.andrew@walrond.org>
 <45DF056C.2010806@wpkg.org> <200702231547.24667.andrew@walrond.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 23 2007 15:47, Andrew Walrond wrote:
>On Friday 23 February 2007 15:17, Tomasz Chmielewski wrote:
>>
>> Try to decrease the initramfs size just to know if it boots correctly.
>>
>> I.e., put just a sh/bash/ash/dash binary there (probably /dev/console
>> node, too), executed in init.
>>
>> Then, try to start the kernel with initramfs embedded in the kernel,
>> then as initrd etc. - this will show if the fault is on your side, or
>> kernel's.
>
>I have tracked this down to a broken version of gnu cpio (latest release, 2.7) 
>which was used to create the initramfs archive. Bloody annoying since this 
>has bitten me before! Last time I even sent the maintainer a bug report, and 
>apparently a fix is in CVS waiting for the next release. Ho hum.

Forgot the -c flag, right?



Jan
-- 
