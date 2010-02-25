Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758816Ab0BYDMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:12:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758762Ab0BYDMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:12:23 -0500
Message-ID: <4B85EA46.5090607@redhat.com>
Date: Wed, 24 Feb 2010 22:11:02 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Li Shaohua <shaohua.li@intel.com>,
       Clemens Ladisch <clemens@ladisch.de>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Olivier Galibert <galibert@pobox.com>, Vivek Goyal <vgoyal@redhat.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/15] readahead: limit readahead size for small devices
References: <20100224031001.026464755@intel.com> <20100224031053.737437080@intel.com>
In-Reply-To: <20100224031053.737437080@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 10:10 PM, Wu Fengguang wrote:
> Linus reports a _really_ small&  slow (505kB, 15kB/s) USB device,
> on which blkid runs unpleasantly slow. He manages to optimize the blkid
> reads down to 1kB+16kB, but still kernel read-ahead turns it into 48kB.

> CC: Li Shaohua<shaohua.li@intel.com>
> CC: Clemens Ladisch<clemens@ladisch.de>
> Acked-by: Jens Axboe<jens.axboe@oracle.com>
> Tested-by: Vivek Goyal<vgoyal@redhat.com>
> Tested-by: Linus Torvalds<torvalds@linux-foundation.org>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>
