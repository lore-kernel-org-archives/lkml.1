Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYKJIZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYKJIZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 03:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbYKJIZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 03:25:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34618 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbYKJIZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 03:25:37 -0500
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] OProfile fixes for v2.6.28
From: Andi Kleen <andi@firstfloor.org>
References: <20081107171339.GQ9785@erda.amd.com>
	<4917EB51.9020304@cosmosbay.com>
Date: Mon, 10 Nov 2008 09:43:05 +0100
In-Reply-To: <4917EB51.9020304@cosmosbay.com> (Eric Dumazet's message of "Mon, 10 Nov 2008 09:05:37 +0100")
Message-ID: <87ljvsott2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <dada1@cosmosbay.com> writes:

> diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
> index 3f1b81a..716d26f 100644
> --- a/arch/x86/oprofile/op_model_ppro.c
> +++ b/arch/x86/oprofile/op_model_ppro.c
> @@ -69,7 +69,7 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
>  	int i;
>  
>  	if (!reset_value) {
> -		reset_value = kmalloc(sizeof(unsigned) * num_counters,
> +		reset_value = kmalloc(sizeof(reset_value[0]) * num_counters,

Thanks for tracking this down.

But that still doesn't explain why 2.6.27 fails too?

-Andi

-- 
ak@linux.intel.com
