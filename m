Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab0BYEDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 23:03:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab0BYEDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 23:03:24 -0500
Message-ID: <4B85F648.1080607@redhat.com>
Date: Wed, 24 Feb 2010 23:02:16 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       Matt Mackall <mpm@selenic.com>, David Woodhouse <dwmw2@infradead.org>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Clemens Ladisch <clemens@ladisch.de>,
       Olivier Galibert <galibert@pobox.com>, Vivek Goyal <vgoyal@redhat.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/15] readahead: bump up the default readahead size
References: <20100224031001.026464755@intel.com> <20100224031054.032435626@intel.com>
In-Reply-To: <20100224031054.032435626@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 10:10 PM, Wu Fengguang wrote:
> Use 512kb max readahead size, and 32kb min readahead size.
>
> The former helps io performance for common workloads.
> The latter will be used in the thrashing safe context readahead.

> CC: Jens Axboe<jens.axboe@oracle.com>
> CC: Chris Mason<chris.mason@oracle.com>
> CC: Peter Zijlstra<a.p.zijlstra@chello.nl>
> CC: Martin Schwidefsky<schwidefsky@de.ibm.com>
> CC: Paul Gortmaker<paul.gortmaker@windriver.com>
> CC: Matt Mackall<mpm@selenic.com>
> CC: David Woodhouse<dwmw2@infradead.org>
> Tested-by: Vivek Goyal<vgoyal@redhat.com>
> Tested-by: Christian Ehrhardt<ehrhardt@linux.vnet.ibm.com>
> Acked-by:  Christian Ehrhardt<ehrhardt@linux.vnet.ibm.com>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>
