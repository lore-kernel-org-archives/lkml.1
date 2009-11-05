Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbZKEQ7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbZKEQ7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 11:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbZKEQ7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 11:59:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44939 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169AbZKEQ66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 11:58:58 -0500
Message-ID: <4AF30447.2030705@zytor.com>
Date: Thu, 05 Nov 2009 08:58:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, crypto, Generate .byte code for some new	instructions
 via gas macro
References: <1257403455.22519.249.camel@yhuang-dev.sh.intel.com> <20091105142336.GB1910@gondor.apana.org.au>
In-Reply-To: <20091105142336.GB1910@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2009 06:23 AM, Herbert Xu wrote:
> On Thu, Nov 05, 2009 at 02:44:15PM +0800, Huang Ying wrote:
>> It will take some time for binutils (gas) to support some newly added
>> instructions, such as SSE4.1 instructions or the AES-NI instructions
>> found in upcoming Intel CPU.
>>
>> To make the source code can be compiled by old binutils, .byte code is
>> used instead of the assembly instruction. But the readability and
>> flexibility of raw .byte code is not good.
>>
>> This patch solves the issue of raw .byte code via generating it via
>> assembly instruction like gas macro. The syntax is as close as
>> possible to real assembly instruction.
>>
>> Some helper macros such as MODRM is not a full feature
>> implementation. It can be extended when necessary.
>>
>> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> Once Ingo acks this I'll throw it into cryptodev.
> 

I'm not Ingo, but:

Acked-by: H. Peter Anvin <hpa@zytor.com>

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

