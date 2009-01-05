Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbZAEWHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbZAEWHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbZAEWH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:07:27 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:52575 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbZAEWH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:07:27 -0500
Date: Mon, 5 Jan 2009 22:07:25 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [regression 2.6.27.10 & 2.6.28] \"nolapic\" option causes
 \"nosmp\"?
In-Reply-To: <200901050318.n053Iu0L068557@www262.sakura.ne.jp>
Message-ID: <alpine.LFD.1.10.0901052156460.10676@ftp.linux-mips.org>
References: <200901050318.n053Iu0L068557@www262.sakura.ne.jp>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Tetsuo Handa wrote:

> Adding "nolapic" option to kernel command line causes /proc/cpuinfo to show
> only 1 CPU, while the machine has 2 CPUs and the kernel was compiled with
> CONFIG_SMP=y.
> 
> Something is wrong with CPU recognition/initialization code?

 This is correct behaviour.  The hardware uses the local APIC to 
communicate between CPUs.  With the subsystem disabled there is no way to 
reach secondary CPUs on a standard x86 system.

> This topic is continued from http://lkml.org/lkml/2008/12/30/104 .
> I confirmed that this problem occurs on native Ubuntu 8.04 (i386) and
> native CentOS 5.2 (x86_64) on ThinkPad X60 (Core 2 Duo).
> 
> Kernel 2.6.26.8 seems to be OK.

 If this is the case, then "nolapic" must have been dysfunctional in that 
version of the kernel.

  Maciej
