Return-Path: <linux-kernel-owner+w=401wt.eu-S1763828AbYD2Us2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763828AbYD2Us2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759437AbYD2Urf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:47:35 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:13294 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761052AbYD2Urc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:47:32 -0400
Date: Tue, 29 Apr 2008 13:46:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: yhlu.kernel@gmail.com
Cc: Yinghai Lu <yhlu.kernel.send@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86: mtrr cleanup for converting continuous to
 discrete layout v8
Message-Id: <20080429134617.1bc3b2d5.randy.dunlap@oracle.com>
In-Reply-To: <200804290352.33543.yhlu.kernel@gmail.com>
References: <200804272337.40130.yhlu.kernel@gmail.com>
	<200804281505.05764.yhlu.kernel@gmail.com>
	<200804290200.33459.yhlu.kernel@gmail.com>
	<200804290352.33543.yhlu.kernel@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 03:52:33 -0700 Yinghai Lu wrote:

> Index: linux-2.6/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/kernel-parameters.txt
> +++ linux-2.6/Documentation/kernel-parameters.txt
> @@ -595,6 +595,20 @@ and is between 256 and 4096 characters. 
>  			See drivers/char/README.epca and
>  			Documentation/digiepca.txt.
>  
> +	disable_mtrr_cleanup [X86]
> +	enable_mtrr_cleanup [X86]
> +			The kernel tries to adjust MTRR layout from continuous
> +			to discrete, to make X server driver able to add WB
> +			entry later. This parameter enables/disables that.
> +
> +	mtrr_chunk_size=nn[KMG] [X86]
> +			used for mtrr cleanup. It is largest continous chunk
> +			that could hold holes aka. UC entries.
> +
> +	mtrr_gran_size=nn[KMG] [X86]
> +			used for mtrr cleanup. It is granity of mtrr block.

s/granity/granularity/
I think that's what you mean/want.

How does someone know that size/granity/whatever of an mtrr block?


> +			Big value could prevent small alignment use up MTRRs.
> +
>  	disable_mtrr_trim [X86, Intel and AMD only]
>  			By default the kernel will trim any uncacheable
>  			memory out of your available memory pool based on

---
~Randy
