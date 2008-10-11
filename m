Return-Path: <linux-kernel-owner+w=401wt.eu-S1762837AbYJKSTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762837AbYJKSTl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 14:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758904AbYJKSTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 14:19:33 -0400
Received: from fb2.tech.numericable.fr ([82.216.111.50]:55333 "EHLO
	fb2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762704AbYJKSTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 14:19:32 -0400
Message-ID: <48F0EFC7.3000204@numericable.fr>
Date: Sat, 11 Oct 2008 20:26:15 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008092811)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [2.6.27-git1] compilation warning with mtrr_cleanup
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,


I have this compilation warning with fresh 2.6.27-git1 kernel :

arch/x86/kernel/cpu/mtrr/main.c: In function ‘mtrr_cleanup’:
arch/x86/kernel/cpu/mtrr/main.c:1363: attention : ‘gran_factor’ may be 
used uninitialized in this function
arch/x86/kernel/cpu/mtrr/main.c:1364: attention : ‘gran_base’ may be 
used uninitialized in this function

WARNING: kernel/built-in.o(.text+0x10690): Section mismatch in reference 
from the function notify_cpu_starting() to the variable 
.cpuinit.data:cpu_chain
The function notify_cpu_starting() references
the variable __cpuinitdata cpu_chain.
This is often because notify_cpu_starting lacks a __cpuinitdata
annotation or the annotation of cpu_chain is wrong.

Regards.

