Return-Path: <linux-kernel-owner+w=401wt.eu-S1760994AbYBHHLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760994AbYBHHLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 02:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYBHHKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 02:10:55 -0500
Received: from relay2.sgi.com ([192.48.171.30]:33930 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757005AbYBHHKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 02:10:54 -0500
Date: Thu, 7 Feb 2008 23:10:01 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andi Kleen <andi@firstfloor.org>,
       Richard Knutsson <ricknu-0@student.ltu.se>
Subject: Re: [PATCH 1/2] kmemcheck v3
In-Reply-To: <47AB79D4.2070605@gmail.com>
Message-ID: <Pine.LNX.4.64.0802072307040.22292@schroedinger.engr.sgi.com>
References: <47AB79D4.2070605@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008, Vegard Nossum wrote:

> - DMA can be a problem since there's generally no way for kmemcheck to
>   determine when/if a chunk of memory is used for DMA. Ideally, DMA should be
>   allocated with untracked caches, but this requires annotation of the
>   drivers in question.

There is a fundamental misunderstanding here: GFP_DMA allocations have 
nothing to do with DMA. Rather GFP_DMA means allocate memory in a special 
range of physical memory that is required by legacy devices that cannot 
use the high address bits for one or the other reason. Any regular 
memory can be used for DMA.

Could you refactor the patch a bit? This is quite a big patch.

