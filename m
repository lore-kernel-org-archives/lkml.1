Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934887Ab0BZBe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 20:34:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934850Ab0BZBe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 20:34:26 -0500
Message-ID: <4B8724EC.1090904@redhat.com>
Date: Thu, 25 Feb 2010 20:33:32 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Clemens Ladisch <clemens@ladisch.de>,
       Olivier Galibert <galibert@pobox.com>, Vivek Goyal <vgoyal@redhat.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Matt Mackall <mpm@selenic.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/15] readahead: pagecache context based mmap read-around
References: <20100224031001.026464755@intel.com> <20100224031055.738182009@intel.com>
In-Reply-To: <20100224031055.738182009@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 10:10 PM, Wu Fengguang wrote:
> Do mmap read-around when there are cached pages in the nearby 256KB
> (covered by one radix tree node).
>
> There is a failure case though: for a sequence of page faults at page
> index 64*i+1, i=1,2,3,..., this heuristic will keep doing pointless
> read-arounds.  Hopefully the pattern won't appear in real workloads.
> Note that the readahead heuristic has similiar failure case.
>
> CC: Nick Piggin<npiggin@suse.de>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

