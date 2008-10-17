Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbYJQJEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbYJQJEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 05:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYJQJEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 05:04:36 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:61373 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbYJQJEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 05:04:35 -0400
X-BigFish: VPS-47(zz62a3L1432R98dR936eQ4015M1805M936fOzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K8VL78-02-55U-01
Date: Fri, 17 Oct 2008 11:04:05 +0200
From: Robert Richter <robert.richter@amd.com>
To: Chris J Arges <arges@linux.vnet.ibm.com>
CC: oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Maynard Johnson <maynardj@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] oprofile: hotplug cpu fix
Message-ID: <20081017090405.GP1029@erda.amd.com>
References: <48F631E9.1010707@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48F631E9.1010707@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Oct 2008 09:04:21.0496 (UTC) FILETIME=[58070780:01C93037]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.10.08 12:09:45, Chris J Arges wrote:
> From 60f07301d3c387a0405becccbdc0cfb7e99ecf39 Mon Sep 17 00:00:00 2001
> From: Chris J Arges <arges@linux.vnet.ibm.com>
> Date: Wed, 15 Oct 2008 11:03:39 -0500
> Subject: [PATCH] oprofile: hotplug cpu fix
>  This patch addresses problems when hotplugging cpus while profiling.
>  Instead of allocating only online cpus, all possible cpu buffers are
>  allocated, which allows cpus to be onlined during operation. If a cpu is
>  offlined before profiling is shutdown wq_sync_buffer checks for this
>  condition then cancels this work and does not sync this buffer.
> 

Applied to oprofile/oprofile-for-tip. Thanks, Chris.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

