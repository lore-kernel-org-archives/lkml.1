Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbYKKH5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbYKKH5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 02:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbYKKH5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 02:57:33 -0500
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:42321 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYKKH5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 02:57:33 -0500
Message-ID: <49193D1A.9040000@numericable.fr>
Date: Tue, 11 Nov 2008 09:06:50 +0100
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008101911)
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re:[PATCH 1/2] x86: Fixing improper annotation.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rakib,


Your two patches set for x86 init_thread_xsate function section mismatch 
is correct to fix the compilation warning, but generates this other one :

> WARNING: vmlinux.o(.cpuinit.text+0x7de): Section mismatch in reference 
> from the function xsave_cntxt_init() to the function 
> .init.text:__alloc_bootmem()
> The function __cpuinit xsave_cntxt_init() references
> a function __init __alloc_bootmem().
> If __alloc_bootmem is only used by xsave_cntxt_init then
> annotate __alloc_bootmem with a matching annotation.
Thanks for your good job.

Regards.
