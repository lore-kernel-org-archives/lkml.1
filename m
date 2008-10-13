Return-Path: <linux-kernel-owner+w=401wt.eu-S1757747AbYJMQtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbYJMQtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 12:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbYJMQtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 12:49:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:44651 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132AbYJMQtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 12:49:06 -0400
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Message-Id: <141BB874-FDA4-4107-BEF6-15B84023E44B@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: avorontsov@ru.mvista.com
In-Reply-To: <20081009003259.GA8373@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH] powerpc: fix fsl_upm nand driver modular build
Date: Mon, 13 Oct 2008 11:48:38 -0500
References: <20081008222815.GA20542@redhat.com> <20081008230219.GA8075@oksana.dev.rtsoft.ru> <20081008233306.GA31771@redhat.com> <20081009003259.GA8373@oksana.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 8, 2008, at 7:32 PM, Anton Vorontsov wrote:

> The fsl_upm nand driver fails to build because fsl_lbc_lock isn't
> exported, the lock is needed by the inlined fsl_upm_run_pattern()
> function:
>
> ERROR: "fsl_lbc_lock" [drivers/mtd/nand/fsl_upm.ko] undefined!
>
> Dave Jones purposed to export the lock, but it is better to just  
> uninline
> the fsl_upm_run_pattern().
>
> When uninlined we also no longer need the exported fsl_lbc_regs, and
> both fsl_lbc_lock and fsl_lbc_regs could be marked static.
>
> While at it, also add some missing includes that we should have  
> included
> explicitly.
>
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---


applied.

- k
