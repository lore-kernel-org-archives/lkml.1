Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbYKKX4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbYKKX4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 18:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYKKX4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 18:56:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773AbYKKX43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 18:56:29 -0500
Date: Tue, 11 Nov 2008 15:56:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       travis@sgi.com, sfr@canb.auug.org.au, vegard.nossum@gmail.com
Subject: Re: [patch 0/7] cpu alloc stage 2
Message-Id: <20081111155611.93b978df.akpm@linux-foundation.org>
In-Reply-To: <20081105231634.133252042@quilx.com>
References: <20081105231634.133252042@quilx.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Nov 2008 17:16:34 -0600
Christoph Lameter <cl@linux-foundation.org> wrote:

> The second stage of the cpu_alloc patchset can be pulled from
> 
> git.kernel.org/pub/scm/linux/kernel/git/christoph/work.git cpu_alloc_stage2
> 
> Stage 2 includes the conversion of the page allocator
> and slub allocator to the use of the cpu allocator.
> 
> It also includes the core of the atomic vs. interrupt cpu ops and uses those
> for the vm statistics.

It all looks very nice to me.  It's a shame about the lack of any
commonality with local_t though.
