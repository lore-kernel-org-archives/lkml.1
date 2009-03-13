Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbZCMFLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbZCMFLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbZCMFK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:10:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:40578 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbZCMFK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:10:56 -0400
Subject: Re: GPU scheduling
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <804dabb00903122102s3d91dff9jd36958a5c7bf0843@mail.gmail.com>
References: <804dabb00903122102s3d91dff9jd36958a5c7bf0843@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 10:40:43 +0530
Message-Id: <1236921043.2553.11.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 12:02 +0800, Peter Teoh wrote:
> Firstly I am a newbie in this area of GPU.   Does it make sense to
> talk about scheduling tasks on the GPU?   Not the graphics processing
> types of tasks, nor the parallel matrix calculation types, but those
> normally executed by CPU, so as to share workload along with the CPU?
> 
> I supposed the machine codes will be different, right?   But if the
> compiler can generate the opcodes for the GPU, and the GPU and CPU can
> detect concurrent use of memory bus address (for the implementation of
> spinlock - CPU/GPU synchronization), which is synonymous to GPU and
> CPU accessing the same memory for data/instructions, then I don't see
> there is any problem with the "GPU scheduler" implementation concept,
> right?   Or perhaps the hardware does not meet all these requirements?
>   Or any other problems which u can forsee?   (eg, GPU being
> prorietary, the opcodes may not be revealed/available, and therefore
> the internal schedulers is not known to us as well?)

Major issue is almost all GPUs are proprietary and they only provide
libraries for users and do not disclose internals.

And now latest GPUs are running blind race with having thousands of
cores.

--
JSR

