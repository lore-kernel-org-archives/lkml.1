Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbYGXOPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbYGXOPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 10:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYGXOPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 10:15:24 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55293 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYGXOPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 10:15:23 -0400
Message-ID: <48888E7C.7040504@us.ibm.com>
Date: Thu, 24 Jul 2008 09:15:24 -0500
From: Maynard Johnson <maynardj@us.ibm.com>
Reply-To: maynardj@us.ibm.com
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 11/24] x86/oprofile: Add IBS support for AMD CPUs, model
 specific code
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com> <1216753748-11261-12-git-send-email-robert.richter@amd.com>
In-Reply-To: <1216753748-11261-12-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:
> From: Barry Kasindorf <barry.kasindorf@amd.com>
> 
> This patchset supports the new profiling hardware available in the
> latest AMD CPUs in the oProfile driver.
> 
> Signed-off-by: Barry Kasindorf <barry.kasindorf@amd.com>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/oprofile/op_model_athlon.c |  257 +++++++++++++++++++++++++++++++++++
>  1 files changed, 257 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/oprofile/op_model_athlon.c b/arch/x86/oprofile/op_model_athlon.c
> index 40ecb02..229e0b4 100644
> --- a/arch/x86/oprofile/op_model_athlon.c
> +++ b/arch/x86/oprofile/op_model_athlon.c
> @@ -9,9 +9,13 @@
>   * @author Philippe Elie
>   * @author Graydon Hoare
>   * @author Robert Richter <robert.richter@amd.com>
> + * @author Barry Kasindorf
>  */
> 
[snip]
> +
> +struct op_ibs_config {
> +	unsigned long op_enabled;
> +	unsigned long fetch_enabled;
> +	unsigned long max_cnt_fetch;
> +	unsigned long max_cnt_op;
> +	unsigned long rand_en;
> +	unsigned long dispatched_ops;
I don't see dispatched_ops being used either by your kernel driver changes or by 
the userspace changes submitted by Jason.

-Maynard
[snip]

