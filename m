Return-Path: <linux-kernel-owner+w=401wt.eu-S1753560AbYA1R6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbYA1R6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 12:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYA1R5z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 12:57:55 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40625 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYA1R5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 12:57:54 -0500
Date: Mon, 28 Jan 2008 19:32:04 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jeremy@goop.org
Subject: Re: git-x86 oopses in acpi_ps_peek_opcode
Message-ID: <20080128183204.GA25724@one.firstfloor.org>
References: <20080128171907.GA24037@basil.nowhere.org> <20080128173449.GA22487@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128173449.GA22487@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 06:34:49PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > git-x86 tip  5b838c0d9d7269eb4d21532da126b3c90db46c67 with x86-64 defconfig
> > oopses on boot with 
> > 
> > BUG: unable to handle kernel paging request at ffffc20001815000
> > IP: [<ffffffff803773e8>] acpi_ps_peek_opcode+0x4/0x1c
> > PGD 12fc32067 PUD 32fc24067 PMD 32f42c067 PTE 0
> 
> ok, this looks like one of the bugs we fixed in the latest x86.git 
> (freshly released a few minutes ago). Could you please check x86.git#mm 
> with this tip:
> 
>   commit cc77c9972685ea84908eff2fe13114160de5d9cb
>   Author: Thomas Gleixner <tglx@linutronix.de>
>   Date:   Mon Jan 28 18:18:43 2008 +0100
> 
>       x86: cpa: rename global_flush_tlb() to cpa_flush_all()
> 
> do you still see that crash?

New the second oops in allocate_threshold_blocks->sysfs_add_file->kobject_uevent_env
happens (see other mail)

-Andi
