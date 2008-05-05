Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbYEEKOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbYEEKOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 06:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYEEKOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 06:14:07 -0400
Received: from www.tglx.de ([62.245.132.106]:33952 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbYEEKOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:14:06 -0400
Date: Mon, 5 May 2008 12:13:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH REPOST] CPA: Add statistics about state of direct mapping
 v4
In-Reply-To: <20080502094649.GA11185@basil.nowhere.org>
Message-ID: <alpine.LFD.1.10.0805051208240.3318@apollo.tec.linutronix.de>
References: <20080502094649.GA11185@basil.nowhere.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008, Andi Kleen wrote:
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> Signed-off-by: Andi Kleen <andi@firstfloor.org>

Interesting SOB chain :)

> +static unsigned long direct_pages_count[PG_LEVEL_NUM];
> +
> +void __meminit update_page_count(int level, unsigned long pages)

Why __meminit ? This is used in split_large_page()

> +{
> +#ifdef CONFIG_PROC_FS

Why keep an empty function when PROC_FS is disabled ?

Thanks,
	tglx
