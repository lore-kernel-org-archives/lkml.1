Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529Ab0AVRBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0AVRBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 12:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045Ab0AVRBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 12:01:52 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:58251 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab0AVRBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 12:01:51 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zzab9bh1432R98dNzz1202hzz5a6ciz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KWNRAP-02-6R2-02
X-M-MSG: 
Date: Fri, 22 Jan 2010 18:01:37 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Thiago Farina <tfransosi@gmail.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] lib/dma-debug.c: mark file-local struct symbol static.
Message-ID: <20100122170137.GK8665@amd.com>
References: <d9a890882c693c1e1d046e034fb8cfb130eafe31.1263858860.git.tfransosi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d9a890882c693c1e1d046e034fb8cfb130eafe31.1263858860.git.tfransosi@gmail.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 22 Jan 2010 17:01:37.0967 (UTC) FILETIME=[8F8A3BF0:01CA9B84]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 06:57:33PM -0500, Thiago Farina wrote:
> warning: symbol 'filter_fops' was not declared. Should it be static?
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>
> ---
>  lib/dma-debug.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/dma-debug.c b/lib/dma-debug.c
> index 7d2f0b3..ba8b670 100644
> --- a/lib/dma-debug.c
> +++ b/lib/dma-debug.c
> @@ -587,7 +587,7 @@ out_unlock:
>  	return count;
>  }
>  
> -const struct file_operations filter_fops = {
> +static const struct file_operations filter_fops = {
>  	.read  = filter_read,
>  	.write = filter_write,
>  };

Applied to dma-debug/fixes. Thanks.

	Joerg

