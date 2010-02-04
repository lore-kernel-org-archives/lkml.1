Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab0BDIZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:25:07 -0500
Received: from smtprelay02.ispgateway.de ([80.67.29.24]:40176 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab0BDIY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:24:59 -0500
X-Greylist: delayed 150045 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Feb 2010 03:24:59 EST
Message-ID: <4B6A8455.5010403@ladisch.de>
Date: Thu, 04 Feb 2010 09:24:53 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/11] readahead: limit readahead size for small devices
References: <20100202152835.683907822@intel.com> <20100202153316.375570078@intel.com>
In-Reply-To: <20100202153316.375570078@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> Anyone has 512/128MB USB stick?

64 MB, USB full speed:
Bus 003 Device 003: ID 08ec:0011 M-Systems Flash Disk Pioneers DiskOnKey

4KB:    139.339 s, 376 kB/s
16KB:   81.0427 s, 647 kB/s
32KB:   71.8513 s, 730 kB/s
64KB:   67.3872 s, 778 kB/s
128KB:  67.5434 s, 776 kB/s
256KB:  65.9019 s, 796 kB/s
512KB:  66.2282 s, 792 kB/s
1024KB: 67.4632 s, 777 kB/s
2048KB: 69.9759 s, 749 kB/s
