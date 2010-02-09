Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab0BIU1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 15:27:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288Ab0BIU1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 15:27:50 -0500
Date: Tue, 9 Feb 2010 12:26:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 15/35] x86: make 64 bit use early_res instead of bootmem
 before slab
Message-Id: <20100209122632.fc4be9c1.akpm@linux-foundation.org>
In-Reply-To: <1265743966-17065-16-git-send-email-yinghai@kernel.org>
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
	<1265743966-17065-16-git-send-email-yinghai@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Feb 2010 11:32:26 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> +u64 __init find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
> +			 u64 size, u64 align)
> +{
> +	u64 addr, last;
> +
> +	addr = round_up(ei_start, align);

Can we use include/linux/log2.h:roundup_pow_of_two() in this patchset?
