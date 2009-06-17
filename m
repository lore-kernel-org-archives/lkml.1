Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbZFQRO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbZFQRO2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZFQROV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:14:21 -0400
Received: from fifo99.com ([67.223.236.141]:34241 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbZFQROU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:14:20 -0400
Subject: Re: [PATCH] kmemleak: Rename kmemleak_panic to kmemleak_stop
From: Daniel Walker <dwalker@fifo99.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Mel Gorman <mel@csn.ul.ie>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <1245253019.11889.55.camel@pc1117.cambridge.arm.com>
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org>
	 <20090616223649.719ea378.akpm@linux-foundation.org>
	 <20090617111800.GA15261@elte.hu> <20090617113120.GA5061@elte.hu>
	 <1245240677.11889.17.camel@pc1117.cambridge.arm.com>
	 <20090617122803.GD28529@csn.ul.ie>
	 <1245242160.11889.23.camel@pc1117.cambridge.arm.com>
	 <20090617124034.GE28529@csn.ul.ie>
	 <1245243130.11889.27.camel@pc1117.cambridge.arm.com>
	 <84144f020906170601l254d3b29udc688d02426ea247@mail.gmail.com>
	 <1245245007.11889.42.camel@pc1117.cambridge.arm.com>
	 <1245245448.5604.31.camel@penberg-laptop>
	 <1245253019.11889.55.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 10:14:22 -0700
Message-Id: <1245258862.5982.264.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 16:36 +0100, Catalin Marinas wrote:
> This is to avoid the confusion created by the "panic" word.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
> 
> (following Pekka's suggestion)
> 
>  mm/kmemleak.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 25e2034..c1f538e 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -251,7 +251,7 @@ static void kmemleak_disable(void);
>   * recovered from. Kkmemleak will be disabled and further allocation/freeing
>   * tracing no longer available.

Looks like there's a little typo up there, "Kkmemleak" should be
"kmemleak" no ?

Daniel

