Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbYGZRiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbYGZRiN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 13:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbYGZRh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 13:37:59 -0400
Received: from in.cluded.net ([195.159.98.120]:53054 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946AbYGZRh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 13:37:58 -0400
Message-ID: <488B5F93.3060600@uw.no>
Date: Sat, 26 Jul 2008 17:32:03 +0000
From: "Daniel K." <dk@uw.no>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20060307 SeaMonkey/1.5a
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/24] oprofile: Add support for AMD Family 11h
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com> <1216753748-11261-4-git-send-email-robert.richter@amd.com>
In-Reply-To: <1216753748-11261-4-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index 7f3329b..cf28a02 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -422,6 +422,10 @@ int __init op_nmi_init(struct oprofile_operations *ops)
>  			model = &op_athlon_spec;
>  			cpu_type = "x86-64/family10";
>  			break;
> +		case 0x11:
> +			model = &op_athlon_spec;
> +			cpu_type = "x86-64/family11h";

Should the 'h' be dropped, as for family10 above, to keep them similar.


Daniel K.
