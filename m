Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934332Ab0BYWjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:39:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934306Ab0BYWjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:39:47 -0500
Message-ID: <4B86FBE7.9050304@redhat.com>
Date: Thu, 25 Feb 2010 17:38:31 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Chris Mason <chris.mason@oracle.com>,
       Clemens Ladisch <clemens@ladisch.de>,
       Olivier Galibert <galibert@pobox.com>, Vivek Goyal <vgoyal@redhat.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/15] readahead: add tracing event
References: <20100224031001.026464755@intel.com> <20100224031054.876156496@intel.com>
In-Reply-To: <20100224031054.876156496@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 10:10 PM, Wu Fengguang wrote:
> Example output:
>
> # echo 1>  /debug/tracing/events/readahead/enable
> # cp test-file /dev/null
> # cat /debug/tracing/trace  # trimmed output
> readahead-initial(dev=0:15, ino=100177, req=0+2, ra=0+4-2, async=0) = 4
> readahead-subsequent(dev=0:15, ino=100177, req=2+2, ra=4+8-8, async=1) = 8
> readahead-subsequent(dev=0:15, ino=100177, req=4+2, ra=12+16-16, async=1) = 16
> readahead-subsequent(dev=0:15, ino=100177, req=12+2, ra=28+32-32, async=1) = 32
> readahead-subsequent(dev=0:15, ino=100177, req=28+2, ra=60+60-60, async=1) = 24
> readahead-subsequent(dev=0:15, ino=100177, req=60+2, ra=120+60-60, async=1) = 0
>
> CC: Ingo Molnar<mingo@elte.hu>
> CC: Jens Axboe<jens.axboe@oracle.com>
> CC: Steven Rostedt<rostedt@goodmis.org>
> CC: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

