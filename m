Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbYIYUMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbYIYUMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 16:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbYIYUMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 16:12:07 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:21786 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbYIYUMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 16:12:06 -0400
X-BigFish: VPS-32(zcb8kz1432R98dR936eQ62a3L1805Mzzzzz32i6bh43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K7RPFK-01-AKB-01
Date: Thu, 25 Sep 2008 22:10:45 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] oprofile: document undocumented oprofile.p4force
	argument
Message-ID: <20080925201045.GK23557@erda.amd.com>
References: <1219250433-25516-1-git-send-email-andi@firstfloor.org> <1219250433-25516-2-git-send-email-andi@firstfloor.org> <1219250433-25516-3-git-send-email-andi@firstfloor.org> <1219250433-25516-4-git-send-email-andi@firstfloor.org> <1219250433-25516-5-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1219250433-25516-5-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 25 Sep 2008 20:10:50.0724 (UTC) FILETIME=[CE607A40:01C91F4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.08.08 18:40:33, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> It's actually useless now, but document it anyways.

We should rework/remove this (maybe later), if it makes no longer
sense to keep it. If we had have a force_cpu_type implementation this
could be thrown away.

But as long as it is in it's better to have it documented.

-Robert

> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  Documentation/kernel-parameters.txt |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 10c8b1b..5e77e1a 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1491,6 +1491,12 @@ and is between 256 and 4096 characters. It is defined in the file
>  			in oprofile on Intel CPUs.  The kernel selects the
>  			correct default on its own.
>  
> +	oprofile.p4force=1 [X86]
> +			On Intel NetBurst CPUs assume new models are compatible
> +			to older ones. This might allow oprofile to be used when
> +			the kernel doesn't know the CPU, but is slightly dangerous.
> +			Should be obsolete by now.
> +
>  	osst=		[HW,SCSI] SCSI Tape Driver
>  			Format: <buffer_size>,<write_threshold>
>  			See also Documentation/scsi/st.txt.
> -- 
> 1.5.6
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

