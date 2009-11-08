Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbZKHK4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbZKHK4Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 05:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZKHK4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 05:56:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41229 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbZKHK4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 05:56:23 -0500
Date: Sun, 8 Nov 2009 11:56:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Huang Ying <ying.huang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86, crypto, Generate .byte code for some new
 instructions via gas macro
Message-ID: <20091108105619.GF11372@elte.hu>
References: <1257403455.22519.249.camel@yhuang-dev.sh.intel.com>
 <20091105142336.GB1910@gondor.apana.org.au>
 <4AF30447.2030705@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF30447.2030705@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 11/05/2009 06:23 AM, Herbert Xu wrote:
> > On Thu, Nov 05, 2009 at 02:44:15PM +0800, Huang Ying wrote:
> >> It will take some time for binutils (gas) to support some newly added
> >> instructions, such as SSE4.1 instructions or the AES-NI instructions
> >> found in upcoming Intel CPU.
> >>
> >> To make the source code can be compiled by old binutils, .byte code is
> >> used instead of the assembly instruction. But the readability and
> >> flexibility of raw .byte code is not good.
> >>
> >> This patch solves the issue of raw .byte code via generating it via
> >> assembly instruction like gas macro. The syntax is as close as
> >> possible to real assembly instruction.
> >>
> >> Some helper macros such as MODRM is not a full feature
> >> implementation. It can be extended when necessary.
> >>
> >> Signed-off-by: Huang Ying <ying.huang@intel.com>
> > 
> > Once Ingo acks this I'll throw it into cryptodev.
> > 
> 
> I'm not Ingo, but:
> 
> Acked-by: H. Peter Anvin <hpa@zytor.com>

Fine to me too and for future variations thereof.

	Ingo
