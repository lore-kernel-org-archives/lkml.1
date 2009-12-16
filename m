Return-Path: <linux-kernel-owner+w=401wt.eu-S935461AbZLPWhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935461AbZLPWhH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934204AbZLPWhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:37:00 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:32833 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbZLPWg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:36:58 -0500
Date: Wed, 16 Dec 2009 16:41:44 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Vishnu Suresh <Vishnu@freescale.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, dan.j.williams@intel.com,
       linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
       B04825@freescale.com, R58472@freescale.com,
       Dipen Dudhat <Dipen.Dudhat@freescale.com>,
       Maneesh Gupta <Maneesh.Gupta@freescale.com>
Subject: Re: [PATCH v2 2/2] Crypto: Talitos: Support for Async_tx XOR
 offload
Message-Id: <20091216164144.daff5468.kim.phillips@freescale.com>
In-Reply-To: <1260977698-4076-1-git-send-email-Vishnu@freescale.com>
References: <1260977698-4076-1-git-send-email-Vishnu@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2009 22:36:52.0785 (UTC) FILETIME=[439F2210:01CA7EA0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009 21:04:58 +0530
Vishnu Suresh <Vishnu@freescale.com> wrote:

> Expose Talitos's XOR functionality to be used for
> RAID Parity calculation via the Async_tx layer.
> 
> Known Issue:
> When used with fsldma, random crashes are observed
> on some platforms. Hence, inter-operability with fsldma
> is currently disabled
> 
> Thanks to Surender Kumar and Lee Nipper for their help in
> realising this driver
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> Signed-off-by: Dipen Dudhat <Dipen.Dudhat@freescale.com>
> Signed-off-by: Maneesh Gupta <Maneesh.Gupta@freescale.com>
> Signed-off-by: Vishnu Suresh <Vishnu@freescale.com>
> ---
> Changes with respect to v1 as per comments received
> o. Rebased to linux-next as of 20091216
> o. The selection is based exclusive of fsldma
> o. Intoduced a new Kernel Configuration variable
>    *. This enables selecting the Cryptographic functionality
>       of Talitos along with fsldma.
>    *. Disables the XOR parity calculation offload, if fsldma enabled
>       either as kernel in-built or as a module
>    *. Once the inter-operability with fsldma is resolved, this option
>       can be removed

wait, why can't the interoperability bug be fixed in the first place?

Kim
