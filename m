Return-Path: <linux-kernel-owner+w=401wt.eu-S1767575AbXDFKhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767575AbXDFKhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 06:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767582AbXDFKhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 06:37:09 -0400
Received: from outmx035.isp.belgacom.be ([195.238.6.172]:37336 "EHLO
	outmx035.isp.belgacom.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767575AbXDFKhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 06:37:08 -0400
Subject: 2.6.9 won't compile
From: Pedro Mullor =?ISO-8859-1?Q?Jim=E9nez?= <pmullor@skynet.be>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Fri, 06 Apr 2007 12:37:03 +0200
Message-Id: <1175855823.16114.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I downloaded version 2.6.9 of the kernel from kernel.org
I went throught menuconfig, importing the configuration of my current
2.6.15-28-686.

I then tried to compile it but the compilation exits with an error
(below).

I also tried to do make mrproper, got rid of the .config file, made
menuconfig again without importing anything, and when compiling it
failed again.

The reason for me to use this kernel is because I have a VIA VT82C
693A/598/686 chipset and I suffer from perf problems (which google says
only happen since 2.6.10).

Might I request to be personally CC'ed in the answers/comments posted in
response to this post ?

Many thanks in advance for your comments and help!

With kind regards,
Pedro Mullor


  CHK     include/linux/version.h
make[1]: `arch/i386/kernel/asm-offsets.s' is up to date.
  CHK     include/linux/compile.h
  CC      arch/i386/kernel/process.o
arch/i386/kernel/process.c: In function ‘show_regs’:
arch/i386/kernel/process.c:252: warning: pointer targets in passing
argument 2 of ‘show_trace’ differ in signedness
{standard input}: Assembler messages:
{standard input}:813: Error: suffix or operands invalid for `mov'
{standard input}:814: Error: suffix or operands invalid for `mov'
{standard input}:1040: Error: suffix or operands invalid for `mov'
{standard input}:1041: Error: suffix or operands invalid for `mov'
{standard input}:1121: Error: suffix or operands invalid for `mov'
{standard input}:1122: Error: suffix or operands invalid for `mov'
{standard input}:1226: Error: suffix or operands invalid for `mov'
{standard input}:1227: Error: suffix or operands invalid for `mov'
{standard input}:1290: Error: suffix or operands invalid for `mov'
{standard input}:1302: Error: suffix or operands invalid for `mov'
make[1]: *** [arch/i386/kernel/process.o] Error 1
make: *** [arch/i386/kernel] Error 2



