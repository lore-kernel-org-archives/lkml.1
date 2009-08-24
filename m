Return-Path: <linux-kernel-owner+w=401wt.eu-S1752945AbZHXRWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbZHXRWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 13:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZHXRWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 13:22:41 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:38964 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbZHXRWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 13:22:40 -0400
Date: Mon, 24 Aug 2009 09:01:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: ngupta@vflare.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mm-cc@laptop.org
Subject: Re: [PATCH 0/4] compcache: compressed in-memory swapping
Message-Id: <20090824090121.61c6f0ea.randy.dunlap@oracle.com>
In-Reply-To: <200908241007.33844.ngupta@vflare.org>
References: <200908241007.33844.ngupta@vflare.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4A92CBCF.0091:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Aug 2009 10:07:33 +0530 Nitin Gupta wrote:

> (Sorry for long patch[2/4] but its now very hard to split it up).
> 
>  Documentation/blockdev/00-INDEX       |    2 +
>  Documentation/blockdev/ramzswap.txt   |   52 ++
>  drivers/block/Kconfig                 |   22 +
>  drivers/block/Makefile                |    1 +
>  drivers/block/ramzswap/Makefile       |    2 +

I can't find drivers/block/ramzswap/Makefile in the patches...

>  drivers/block/ramzswap/ramzswap.c     | 1511 +++++++++++++++++++++++++++++++++
>  drivers/block/ramzswap/ramzswap.h     |  182 ++++
>  drivers/block/ramzswap/xvmalloc.c     |  556 ++++++++++++
>  drivers/block/ramzswap/xvmalloc.h     |   30 +
>  drivers/block/ramzswap/xvmalloc_int.h |   86 ++
>  include/linux/ramzswap_ioctl.h        |   51 ++
>  include/linux/swap.h                  |    5 +
>  mm/swapfile.c                         |   33 +
>  13 files changed, 2533 insertions(+), 0 deletions(-)


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
