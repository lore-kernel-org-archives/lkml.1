Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbXLLLRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbXLLLRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756452AbXLLLRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:17:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46392 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753517AbXLLLRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:17:17 -0500
Date: Wed, 12 Dec 2007 03:17:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/47] Minor fixes to mm/fault.c for CRIS.
Message-Id: <20071212031713.a7e42829.akpm@linux-foundation.org>
In-Reply-To: <1cafe3040d64fbc0094c804d0840a282f71644e0.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
	<1cafe3040d64fbc0094c804d0840a282f71644e0.1196848533.git.jesper.nilsson@axis.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007 13:59:57 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> @@ -360,7 +247,7 @@ do_page_fault(unsigned long address, struct pt_regs *regs,
>  	up_read(&mm->mmap_sem);
>  	printk("VM: killing process %s\n", tsk->comm);
>  	if (user_mode(regs))
> -		do_group_exit(SIGKILL);
> +		do_exit(SIGKILL);

Is this change correct?
