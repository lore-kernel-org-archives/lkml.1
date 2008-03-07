Return-Path: <linux-kernel-owner+w=401wt.eu-S1762582AbYCGLna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762582AbYCGLna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 06:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbYCGLnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 06:43:06 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:32714 "EHLO
	outbound2-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762085AbYCGLnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 06:43:04 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0JXCZ7D-01-CPC-01
Date: Fri, 7 Mar 2008 12:42:50 +0100
From: Robert Richter <robert.richter@amd.com>
To: stephane eranian <eranian@googlemail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
Subject: Re: [PATCH 2/3] perfmon x86 infrastructure definitions
Message-ID: <20080307114249.GA12930@erda.amd.com>
References: <7c86c4470803062225y4727a19ic321314b292dd874@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470803062225y4727a19ic321314b292dd874@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 07 Mar 2008 11:42:50.0429 (UTC) FILETIME=[5F430ED0:01C88048]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.03.08 22:25:26, stephane eranian wrote:
> adds AMD Northbridge config MSR definition
> 
> Signed-off-by: Stephane Eranian <eranian@gmail.com>
> Signed-off-by: Robert Richter <robert.richter@amd.com>

> --- a/include/asm-x86/msr-index.h
> +++ b/include/asm-x86/msr-index.h
> @@ -83,6 +83,7 @@
>  /* AMD64 MSRs. Not complete. See the architecture manual for a more
>     complete list. */
>  
> +#define MSR_AMD64_NB_CFG		0xc001001f

This will probably not be needed after mm config works fine (patches
from Yinghai Lu). Since the usage of CF8 extended configuration cycles
is not recommended, the current code to enable IBS interrupts can be
seen as temporary. I will rework the IBS code so that it uses mm
config.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

