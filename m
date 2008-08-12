Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbYHLGx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbYHLGx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 02:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYHLGxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 02:53:49 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56316 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbYHLGxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 02:53:48 -0400
Message-ID: <48A1329F.6000602@cs.helsinki.fi>
Date: Tue, 12 Aug 2008 09:50:07 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>, mpm@selenic.com,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 00/19] Slab Fragmentation Reduction V14
References: <20080811150616.207532384@quilx.com>
In-Reply-To: <20080811150616.207532384@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> V13->V14
> - Rediff against linux-next on request of Andrew
> - TestSetPageLocked -> trylock_page conversion.
> 
> Slab fragmentation is mainly an issue if Linux is used as a fileserver
> and large amounts of dentries, inodes and buffer heads accumulate. In some
> load situations the slabs become very sparsely populated so that a lot of
> memory is wasted by slabs that only contain one or a few objects. In
> extreme cases the performance of a machine will become sluggish since
> we are continually running reclaim without much succes.
> Slab defragmentation adds the capability to recover the memory that
> is wasted.

Applied, thanks!
