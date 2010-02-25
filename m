Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934348Ab0BYWnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:43:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934307Ab0BYWnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:43:51 -0500
Message-ID: <4B86FCDE.1010201@redhat.com>
Date: Thu, 25 Feb 2010 17:42:38 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Clemens Ladisch <clemens@ladisch.de>,
       Olivier Galibert <galibert@pobox.com>, Vivek Goyal <vgoyal@redhat.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/15] readahead: dont do start-of-file readahead after
 lseek()
References: <20100224031001.026464755@intel.com> <20100224031055.164120692@intel.com>
In-Reply-To: <20100224031055.164120692@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 10:10 PM, Wu Fengguang wrote:
> Some applications (eg. blkid, id3tool etc.) seek around the file
> to get information. For example, blkid does
> 	     seek to	0
> 	     read	1024
> 	     seek to	1536
> 	     read	16384
>
> The start-of-file readahead heuristic is wrong for them, whose
> access pattern can be identified by lseek() calls.
>
> So test-and-set a READAHEAD_LSEEK flag on lseek() and don't
> do start-of-file readahead on seeing it. Proposed by Linus.
>
> Acked-by: Linus Torvalds<torvalds@linux-foundation.org>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>
