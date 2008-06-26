Return-Path: <linux-kernel-owner+w=401wt.eu-S1757475AbYFZJTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475AbYFZJTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbYFZJTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:19:43 -0400
Received: from wmproxy1-g27.free.fr ([212.27.42.91]:57261 "EHLO
	wmproxy1-g27.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbYFZJTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:19:42 -0400
Message-ID: <1214471767.48635e574384b@imp.free.fr>
Date: Thu, 26 Jun 2008 11:16:07 +0200
From: Gilles Espinasse <g.esp@free.fr>
To: Marian =?iso-8859-1?b?QWxkZW5o9nZlbA==?= 
	<marian.aldenhoevel@mba-software.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Building a kernel for SiS55-based system.
References: <4860959E.6020207@mba-software.de>
In-Reply-To: <4860959E.6020207@mba-software.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
User-Agent: Internet Messaging Program (IMP) 3.2.8
X-Originating-IP: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Selon Marian Aldenhövel <marian.aldenhoevel@mba-software.de>:

> Hi,
>
> I am trying to build a linux kernel for a small form-factor PC. I have so
> far failed to create a working kernel.
>
> Output of /cat/proc/cpuinfo as given by the hardware vendor:
>
>   > processor       : 0
>   > vendor_id       : SiS SiS SiS
>   > cpu family      : 5
>   > model           : 0
>   > model name      : ff/00
>   > stepping        : 5
>   > cpu MHz         : 200.008
>   > fdiv_bug        : no
>   > hlt_bug         : no
>   > f00f_bug        : no
>   > coma_bug        : no
>   > fpu             : yes
>   > fpu_exception   : yes
>   > cpuid level     : 1
>   > wp              : yes
>   > flags           : fpu tsc cx8 mmx
>   > bogomips        : 398.95
>
> I gather that is a SiS 55x System-on-a-chip.
>
> I am using T2[1] as build-system. It (currently) tries to build the kernel
> from 2.6.25.7 sources. When booting the kernel it built the system stops
> after:
>
>    Decompressing Linux... done.
>    Booting the kernel.
>
> At the bottom of the screen it says:
>
>    BUG: Int6: CR2 00000000
>
> And nothing else.
>
Int6 mean invalid opcode

I find same error messages
on opensuse beta with linux-2.6.24 and real hardware
http://forums.opensuse.org/archives/sf-archives/opensuse-beta/347272-updated-last-night-kernel-bug-now.html

on debian kernel under MS VirtualPC
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=463606


What version of gcc,binutils?

Could you try with distrib images to know if it could be related to your
compilation system or use a distrib kernel config to test on your compilation
system?

Instead of CONFIG_M386=y, you may try to select M486 or M586
( maybe later with tsc and mmx as cpuinfo flags line report it is supported).


Gilles
