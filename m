Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbYECTh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbYECTh1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbYECThL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:37:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52300 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbYECThK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:37:10 -0400
Message-ID: <481CBEB5.803@zytor.com>
Date: Sat, 03 May 2008 12:36:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] fix asm-mips/types.h syntax error
References: <20080503192617.GQ5838@cs181133002.pp.htv.fi>
In-Reply-To: <20080503192617.GQ5838@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch fixes the following compile error caused by
> commit 23cf11ddb5099f8c7f7cb3eb154bff0faf31cae9
> (mips: types: use <asm-generic/int-*.h> for the mips architecture):
> 
> <--  snip  -->
> 
> ...
>   CC      kernel/bounds.s
> In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/types.h:12,
>                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/page-flags.h:8,
>                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/kernel/bounds.c:9:
> include2/asm/types.h:56:2: error: #endif without #if
> make[2]: *** [kernel/bounds.s] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

Went through the other patches, too, to verify none of the other 
architectures were similarly affected.

	-hpa
