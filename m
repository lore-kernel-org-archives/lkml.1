Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0BJSNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 13:13:40 -0500
Received: from borg.medozas.de ([188.40.89.202]:54486 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702Ab0BJSNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 13:13:39 -0500
Date: Wed, 10 Feb 2010 19:13:24 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jeremy Fitzhardinge <jeremy@xensource.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org
Subject: Paravirt compile failure with gcc33
Message-ID: <alpine.LSU.2.01.1002101909560.29808@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


As I was compile-testing 2.6.33-rc with gcc-3.3,
binutils-2.19.51-10.26.4.x86_64, I observed a failure when 
CONFIG_PARAVIRT is turned on:


[any file]
/home/jengelh/code/linux/arch/x86/include/asm/paravirt.h: In function 
`rif_seq_stop':
/home/jengelh/code/linux/arch/x86/include/asm/paravirt.h:763: warning: 
asm operand 5 probably doesn't match constraints
/home/jengelh/code/linux/arch/x86/include/asm/paravirt.h:858: warning: 
asm operand 2 probably doesn't match constraints
/home/jengelh/code/linux/arch/x86/include/asm/paravirt.h:763: error: 
impossible constraint in `asm'
/home/jengelh/code/linux/arch/x86/include/asm/paravirt.h:858: error: 
impossible constraint in `asm'

Disabling either PARAVIRT or using GCC4.x works around this.
