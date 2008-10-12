Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbYJLJ5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbYJLJ5r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbYJLJ5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:57:38 -0400
Received: from smtp4.tech.numericable.fr ([82.216.111.40]:40803 "EHLO
	smtp4.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYJLJ5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:57:37 -0400
Message-ID: <48F1CBE6.4030908@numericable.fr>
Date: Sun, 12 Oct 2008 12:05:26 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008092811)
MIME-Version: 1.0
To: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re:[PATCH 0/7] post x86 merge section mismatch fixes
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Marcin,


I have applied your patches on my fresh 2.6.27-git2 kernel and the 
section mismatches are now fixed, just remaining the following:

> WARNING: arch/x86/kernel/built-in.o(.cpuinit.text+0x347): Section 
> mismatch in reference from the function fpu_init() to the function 
> .init.text:init_thread_xstate()
> The function __cpuinit fpu_init() references
> a function __init init_thread_xstate().
> If init_thread_xstate is only used by fpu_init then
> annotate init_thread_xstate with a matching annotation.
>
> WARNING: kernel/built-in.o(.text+0x10690): Section mismatch in 
> reference from the function notify_cpu_starting() to the variable 
> .cpuinit.data:cpu_chain
> The function notify_cpu_starting() references
> the variable __cpuinitdata cpu_chain.
> This is often because notify_cpu_starting lacks a __cpuinitdata
> annotation or the annotation of cpu_chain is wrong.
>
> WARNING: vmlinux.o(.text+0x33264): Section mismatch in reference from 
> the function notify_cpu_starting() to the variable .cpuinit.data:cpu_chain
> The function notify_cpu_starting() references
> the variable __cpuinitdata cpu_chain.
> This is often because notify_cpu_starting lacks a __cpuinitdata
> annotation or the annotation of cpu_chain is wrong.
>
> WARNING: vmlinux.o(.cpuinit.text+0x605): Section mismatch in reference 
> from the function fpu_init() to the function 
> .init.text:init_thread_xstate()
> The function __cpuinit fpu_init() references
> a function __init init_thread_xstate().
> If init_thread_xstate is only used by fpu_init then
> annotate init_thread_xstate with a matching annotation.
Thanks and regards.
