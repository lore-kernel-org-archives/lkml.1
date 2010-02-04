Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab0BDNBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 08:01:11 -0500
Received: from mga14.intel.com ([143.182.124.37]:28879 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757910Ab0BDNBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 08:01:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,404,1262592000"; 
   d="scan'208";a="240396760"
Date: Thu, 4 Feb 2010 21:00:56 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/11] readahead: limit readahead size for small devices
Message-ID: <20100204130056.GB25905@localhost>
References: <20100202152835.683907822@intel.com> <20100202153316.375570078@intel.com> <4B6A8455.5010403@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6A8455.5010403@ladisch.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens,

Thanks for the data!

On Thu, Feb 04, 2010 at 04:24:53PM +0800, Clemens Ladisch wrote:
> Wu Fengguang wrote:
> > Anyone has 512/128MB USB stick?
> 
> 64 MB, USB full speed:
> Bus 003 Device 003: ID 08ec:0011 M-Systems Flash Disk Pioneers DiskOnKey
> 
> 4KB:    139.339 s, 376 kB/s
> 16KB:   81.0427 s, 647 kB/s
> 32KB:   71.8513 s, 730 kB/s
> 64KB:   67.3872 s, 778 kB/s
> 128KB:  67.5434 s, 776 kB/s
> 256KB:  65.9019 s, 796 kB/s
> 512KB:  66.2282 s, 792 kB/s
> 1024KB: 67.4632 s, 777 kB/s
> 2048KB: 69.9759 s, 749 kB/s

It seems to reach good throughput at 64KB readahead size :)

Thanks,
Fengguang
