Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934549Ab0BYXoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:44:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934488Ab0BYXoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:44:02 -0500
Message-ID: <4B870AF1.90300@redhat.com>
Date: Thu, 25 Feb 2010 18:42:41 -0500
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
Subject: Re: [PATCH 14/15] readahead: reduce MMAP_LOTSAMISS for mmap read-around
References: <20100224031001.026464755@intel.com> <20100224031055.594006457@intel.com>
In-Reply-To: <20100224031055.594006457@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 10:10 PM, Wu Fengguang wrote:
> Now that we lifts readahead size from 128KB to 512KB,
> the MMAP_LOTSAMISS shall be shrinked accordingly.
>
> We shrink it a bit more, so that for sparse random access patterns,
> only 10*512KB or ~5MB memory will be wasted, instead of the previous
> 100*128KB or ~12MB. The new threshold "10" is still big enough to avoid
> turning off read-around for typical executable/lib page faults.
>
> CC: Nick Piggin<npiggin@suse.de>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>
