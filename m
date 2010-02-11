Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab0BKVhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 16:37:45 -0500
Received: from waste.org ([173.11.57.241]:35577 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773Ab0BKVhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 16:37:43 -0500
Subject: Re: [PATCH 03/11] readahead: bump up the default readahead size
From: Matt Mackall <mpm@selenic.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Clemens Ladisch <clemens@ladisch.de>,
       Olivier Galibert <galibert@pobox.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       David Woodhouse <dwmw2@infradead.org>, linux-embedded@vger.kernel.org
In-Reply-To: <20100208134634.GA3024@localhost>
References: <20100207041013.891441102@intel.com>
	 <20100207041043.147345346@intel.com> <4B6FBB3F.4010701@linux.vnet.ibm.com>
	 <20100208134634.GA3024@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Feb 2010 15:37:34 -0600
Message-ID: <1265924254.15603.79.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-08 at 21:46 +0800, Wu Fengguang wrote:
> Chris,
> 
> Firstly inform the linux-embedded maintainers :)
> 
> I think it's a good suggestion to add a config option
> (CONFIG_READAHEAD_SIZE). Will update the patch..

I don't have a strong opinion here beyond the nagging feeling that we
should be using a per-bdev scaling window scheme rather than something
static.

-- 
http://selenic.com : development and support for Mercurial and Linux


