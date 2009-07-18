Return-Path: <linux-kernel-owner+w=401wt.eu-S1751636AbZGRM0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636AbZGRM0g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 08:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZGRM0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 08:26:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60500 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbZGRM0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 08:26:35 -0400
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add function to convert between calendar time and broken-down time for universal use
From: Andi Kleen <andi@firstfloor.org>
References: <4A5C3BC0.6020701@cn.fujitsu.com>
Date: Sat, 18 Jul 2009 14:26:32 +0200
In-Reply-To: <4A5C3BC0.6020701@cn.fujitsu.com> (zhaolei@cn.fujitsu.com's message of "Tue, 14 Jul 2009 16:03:12 +0800")
Message-ID: <87skguuqh3.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhaolei <zhaolei@cn.fujitsu.com> writes:
> +
> +static void __offtime(__kernel_time_t totalsecs, int offset,
> +         unsigned int *year, unsigned int *mon, unsigned int *mday,
> +         unsigned int *hour, unsigned int *min, unsigned int *sec,
> +         unsigned int *wday, unsigned int *yday)
> +{
> +    long days, rem, y;
> +    const unsigned short *ip;
> +
> +    days = totalsecs / SECS_PER_DAY;

Does this handle leap seconds? Doesn't seem to.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
