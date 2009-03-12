Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbZCLF42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbZCLF42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 01:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbZCLF4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 01:56:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44589 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZCLF4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 01:56:07 -0400
Message-ID: <49B8A3BB.1050001@zytor.com>
Date: Wed, 11 Mar 2009 22:55:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mark Langsdorf <mark.langsdorf@amd.com>
CC: Andrew Morton <akpm@linux-foundation.org>, eric@lammerts.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][retry 4] Conform L3 Cache Index Disable to Linux standards
References: <200903110921.16755.mark.langsdorf@amd.com>
In-Reply-To: <200903110921.16755.mark.langsdorf@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Langsdorf wrote:
>     Add ABI Documentation entry and fix some /sys directory formating
>     issues with the L3 Cache Index Disable feature for future AMD
>     processors.  Add a check to disable it for family 0x10 models
>     that do not support it yet.
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>

Hi there,

This patch fails to build with "make allnoconfig":


/home/hpa/kernel/linux-2.6-tip.cache/arch/x86/kernel/k8.c: In function
‘next_k8_northbridge’:
/home/hpa/kernel/linux-2.6-tip.cache/arch/x86/kernel/k8.c:34: error:
implicit declaration of function ‘pci_match_id’

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

