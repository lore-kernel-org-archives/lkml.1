Return-Path: <linux-kernel-owner+w=401wt.eu-S932648AbZLSA3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932648AbZLSA3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 19:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbZLSA3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 19:29:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:36918 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689AbZLSA2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 19:28:49 -0500
Message-ID: <4B2C1DFF.7090405@kernel.org>
Date: Fri, 18 Dec 2009 16:27:43 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] x86: move range related operation to one file
References: <4B2B4C19.6010402@kernel.org> <4B2B4F85.5030901@kernel.org> <4B2BE1BF.60803@zytor.com> <4B2BE348.207@kernel.org> <4B2BF38F.3090101@zytor.com> <4B2C14A3.90906@kernel.org> <4B2C1D69.8090703@zytor.com>
In-Reply-To: <4B2C1D69.8090703@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 12/18/2009 03:47 PM, Yinghai Lu wrote:
>> i could try to merge range handling to to early_res handling code.
>> first step is change the end in range to be consistent to the one in early_res.
>>
>> later could move them into kernel/range.c or kernel/early_res.c after we convert all bootmem to early_res.
>>
> 
> Seems reasonable, I guess.
> 

can you put current 9 patches into tip? i will submit following patch that merge range and early_res

Thanks

Yinghai
