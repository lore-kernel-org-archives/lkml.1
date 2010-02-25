Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934541Ab0BYXiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 18:38:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934520Ab0BYXix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 18:38:53 -0500
Message-ID: <4B8709BA.8090500@redhat.com>
Date: Thu, 25 Feb 2010 18:37:30 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Clemens Ladisch <clemens@ladisch.de>,
       Olivier Galibert <galibert@pobox.com>, Vivek Goyal <vgoyal@redhat.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/15] radixtree: speed up the search for hole
References: <20100224031001.026464755@intel.com> <20100224031055.460494682@intel.com>
In-Reply-To: <20100224031055.460494682@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 10:10 PM, Wu Fengguang wrote:
> Replace the hole scan functions with more fast versions:
> 	- radix_tree_next_hole(root, index, max_scan)
> 	- radix_tree_prev_hole(root, index, max_scan)
>
> Cc: Nick Piggin<nickpiggin@yahoo.com.au>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>
