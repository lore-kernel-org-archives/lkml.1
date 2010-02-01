Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab0BATI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 14:08:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55911 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583Ab0BATIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 14:08:55 -0500
Message-ID: <4B6726AA.4000009@zytor.com>
Date: Mon, 01 Feb 2010 11:08:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Emese Revfy <re.emese@gmail.com>
CC: mingo@redhat.com, tglx@linutronix.de, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Constify struct mtrr_ops for v2.6.33-rc6
References: <4B65D712.3080804@gmail.com>
In-Reply-To: <4B65D712.3080804@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2010 11:16 AM, Emese Revfy wrote:
> From: Emese Revfy <re.emese@gmail.com>
> 
> Constify struct mtrr_ops.
> 
> This is part of the ops structure constification
> effort started by Arjan van de Ven et al.
> 
> Benefits of this constification:
> 
>  * prevents modification of data that is shared
>    (referenced) by many other structure instances
>    at runtime
> 
>  * detects/prevents accidental (but not intentional)
>    modification attempts on archs that enforce
>    read-only kernel data at runtime
> 
>  * potentially better optimized code as the compiler
>    can assume that the const data cannot be changed
> 
>  * the compiler/linker move const data into .rodata
>    and therefore exclude them from false sharing
> 
> Signed-off-by: Emese Revfy <re.emese@gmail.com>
> Acked-by: H. Peter Anvin <hpa@zytor.com>

Yes, but this doesn't exactly seem like 2.6.33 matter.  I will put it in
-tip for 2.6.34.

	-hpa
