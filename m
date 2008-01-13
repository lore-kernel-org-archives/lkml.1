Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbYAMB3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbYAMB3J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 20:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYAMB27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 20:28:59 -0500
Received: from mail.nagafix.co.uk ([194.145.196.85]:60010 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbYAMB26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 20:28:58 -0500
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Jan 2008 20:28:58 EST
Message-ID: <47896711.4050909@nagafix.co.uk>
Date: Sun, 13 Jan 2008 01:19:13 +0000
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Carlo Marcelo Arenas Belon <carenas@sajinet.com.pe>
CC: Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [kvm-devel] boot stops after console handover?
References: <47812BC3.6060503@nagafix.co.uk> <4781EDE3.2000008@qumranet.com> <47827DE4.2020306@nagafix.co.uk> <47833572.7090902@qumranet.com> <4783C6CC.1050404@nagafix.co.uk> <478901D7.1060404@nagafix.co.uk> <47892AA8.6090406@qumranet.com> <20080112222501.GA17084@tapir>
In-Reply-To: <20080112222501.GA17084@tapir>
X-Enigmail-Version: 0.95.5
OpenPGP: id=F18AD6BB;
	url=http://users.nagafix.co.uk/~antoine/antoine.asc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlo Marcelo Arenas Belon wrote:
> On Sat, Jan 12, 2008 at 11:01:28PM +0200, Avi Kivity wrote:
>> Antoine Martin wrote:
>>
>>> FYI, just tried building 2.6.24-rc7-git4 and got this warning:
>>> (...)
>> Probably harmless, but worth reporting to lkml.
> 
> couldn't replicate it here, but I'd seen usually those kind of errors
> when building a kernel that hasn't been "mrproper" between re-configurations
> 
cp .config ../config-2.6.24-rc7-git4
make mrproper
cp ../config-2.6.24-rc7-git4 .config
make -j 4
(...)
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x2cb657): Section mismatch: reference to
.init.text:register_cpu_notifier (between 'kvm_init_x86' and 'kvm_sched_in')
WARNING: vmlinux.o(.text.head+0xe4): Section mismatch: reference to
.init.data.2:trampoline_level4_pgt (between 'ident_complete' and
'secondary_startup_64')
WARNING: vmlinux.o(.text.head+0xeb): Section mismatch: reference to
.init.data.2:trampoline_level4_pgt (between 'ident_complete' and
'secondary_startup_64')
  LD      vmlinux
  SYSMAP  System.map
  SYSMAP  .tmp_System.map

You can grab the .config here:
http://194.145.196.85/kvm/config-2.6.24-rc7-git4

Antoine
