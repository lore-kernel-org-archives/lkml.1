Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbYJ0S0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbYJ0S0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYJ0S0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:26:40 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:49600 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYJ0S0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:26:39 -0400
X-BigFish: VPS-33(z34a4jz62a3L1432R98dR936eQ1805Mzzzzz32i6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K9ETVV-02-7DN-01
Date: Mon, 27 Oct 2008 19:26:02 +0100
From: Robert Richter <robert.richter@amd.com>
To: Carl Love <cel@us.ibm.com>
CC: oprofile-list@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       cel@linux.vnet.ibm.com, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Cbe-oss-dev] [PATCH] Cell OProfile: Incorrect local array
	size in activate spu profiling function
Message-ID: <20081027182602.GE9785@erda.amd.com>
References: <1224874049.20229.5.camel@carll-linux-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1224874049.20229.5.camel@carll-linux-desktop>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 27 Oct 2008 18:26:24.0673 (UTC) FILETIME=[84BCF910:01C93861]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.10.08 11:47:29, Carl Love wrote:
> 
> The size of the pm_signal_local array should be equal to the
> number of SPUs being configured in the call.  Currently, the
> array is of size 4 (NR_PHYS_CTRS) but being indexed by a for 
> loop from 0 to 7 (NUM_SPUS_PER_NODE).  
> 
> Signed-off-by: Carl Love <carll@us.ibm.com>

I applied your patch to oprofile/oprofile-for-tip. Thanks Carl.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

