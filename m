Return-Path: <linux-kernel-owner+w=401wt.eu-S1759294AbYLDAN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbYLDAN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 19:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758148AbYLDAFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 19:05:44 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:19096 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818AbYLDAFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 19:05:43 -0500
X-BigFish: VPS-42(zz1432R62a3L98dR936eQ4015M1805Mzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBBS8X-02-FWX-01
Date: Thu, 4 Dec 2008 01:04:45 +0100
From: Robert Richter <robert.richter@amd.com>
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofile: fix CPU unplug panic in ppro_stop()
Message-ID: <20081204000445.GL11656@erda.amd.com>
References: <4934D3E1.1000507@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4934D3E1.1000507@cosmosbay.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 04 Dec 2008 00:05:22.0596 (UTC) FILETIME=[005E7E40:01C955A4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.12.08 07:21:21, Eric Dumazet wrote:
> If oprofile statically compiled in kernel, a cpu unplug triggers
> a panic in ppro_stop(), because a NULL pointer is dereferenced.
>
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

Eric, I applied your patch and it will go upstream for 2.6.28.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

