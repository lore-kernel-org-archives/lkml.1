Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbYKQR6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbYKQR6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 12:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYKQR6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 12:58:09 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:54485 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbYKQR6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 12:58:08 -0500
X-BigFish: VPS-35(zz1432R62a3L98dR936eQ1805Mzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KAHOK8-02-EZU-01
Date: Mon, 17 Nov 2008 18:57:09 +0100
From: Robert Richter <robert.richter@amd.com>
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: [git pull] OProfile fixes for v2.6.28
Message-ID: <20081117175708.GJ1664@erda.amd.com>
References: <20081107171339.GQ9785@erda.amd.com> <4917EB51.9020304@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4917EB51.9020304@cosmosbay.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Nov 2008 17:57:38.0615 (UTC) FILETIME=[FA9A2C70:01C948DD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.11.08 09:05:37, Eric Dumazet wrote:
> [PATCH] oprofile: fix an overflow in ppro code
>
> reset_value was changed from long to u64 in commit 
> b99170288421c79f0c2efa8b33e26e65f4bb7fb8
> (oprofile: Implement Intel architectural perfmon support)
>
> But dynamic allocation of this array use a wrong type (long instead of u64)
>
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

Applied to oprofile/oprofile-for-tip. Thanks Eric.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

