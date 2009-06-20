Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbZFTBvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbZFTBvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZFTBv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:51:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59791 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbZFTBv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:51:28 -0400
Message-ID: <4A3C4083.2080205@redhat.com>
Date: Fri, 19 Jun 2009 21:50:59 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       npiggin@suse.de, chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, Avi Kivity <avi@redhat.com>, jeremy@goop.org,
       alan@lxorguk.ukuu.org.uk, Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/4] tmem: infrastructure for tmem layer
References: <b6ebd2d7-7bac-4aa0-8910-991304979fb9@default>
In-Reply-To: <b6ebd2d7-7bac-4aa0-8910-991304979fb9@default>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Magenheimer wrote:

> --- linux-2.6.30/mm/Makefile	2009-06-09 21:05:27.000000000 -0600
> +++ linux-2.6.30-tmem/mm/Makefile	2009-06-19 09:33:59.000000000 -0600
> @@ -16,6 +16,8 @@
>  obj-$(CONFIG_PROC_PAGE_MONITOR) += pagewalk.o
>  obj-$(CONFIG_BOUNCE)	+= bounce.o
>  obj-$(CONFIG_SWAP)	+= page_io.o swap_state.o swapfile.o thrash.o
> +obj-$(CONFIG_PRESWAP)	+= preswap.o
> +obj-$(CONFIG_PRECACHE)	+= precache.o

This patch does not actually add preswap.c or precache.c,
so it would lead to an uncompilable changeset.

This in turn breaks git bisect.

Please make sure that every changeset that is applied results
in a compilable and bootable kernel.

-- 
All rights reversed.
