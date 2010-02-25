Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934311Ab0BYWjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:39:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46918 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934167Ab0BYWjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:39:20 -0500
Message-ID: <4B86FBAB.6070807@redhat.com>
Date: Thu, 25 Feb 2010 17:37:31 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Chris Mason <chris.mason@oracle.com>,
       Clemens Ladisch <clemens@ladisch.de>,
       Olivier Galibert <galibert@pobox.com>, Vivek Goyal <vgoyal@redhat.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/15] readahead: record readahead patterns
References: <20100224031001.026464755@intel.com> <20100224031054.734136802@intel.com>
In-Reply-To: <20100224031054.734136802@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 10:10 PM, Wu Fengguang wrote:
> Record the readahead pattern in ra_flags. This info can be examined by
> users via the readahead tracing/stats interfaces.
>
> Currently 7 patterns are defined:
>
>        	pattern			readahead for
> -----------------------------------------------------------
> 	RA_PATTERN_INITIAL	start-of-file/oversize read
> 	RA_PATTERN_SUBSEQUENT	trivial     sequential read
> 	RA_PATTERN_CONTEXT	interleaved sequential read
> 	RA_PATTERN_THRASH	thrashed    sequential read
> 	RA_PATTERN_MMAP_AROUND	mmap fault
> 	RA_PATTERN_FADVISE	posix_fadvise()
> 	RA_PATTERN_RANDOM	random read
>
> CC: Ingo Molnar<mingo@elte.hu>
> CC: Jens Axboe<jens.axboe@oracle.com>
> CC: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

