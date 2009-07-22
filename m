Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbZGVVA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbZGVVA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 17:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZGVVA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 17:00:58 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:57057 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbZGVVA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 17:00:58 -0400
Date: Wed, 22 Jul 2009 13:59:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Trivial Patch Monkey <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] power: trivial comment fixes
Message-Id: <20090722135930.756e2ada.randy.dunlap@oracle.com>
In-Reply-To: <200907170319.02997.rjw@sisk.pl>
References: <20090716134257.GA22163@localhost>
	<200907170319.02997.rjw@sisk.pl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4A677DB4.0193:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009 03:19:02 +0200 Rafael J. Wysocki wrote:

> On Thursday 16 July 2009, Wu Fengguang wrote:
> > CC: Rafael J. Wysocki <rjw@sisk.pl>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> Thanks for the patch, I'll add it to the suspend tree when I'm back home
> (probably on Monday).
> 
> Best,
> Rafael
> 
> 
> > ---
> >  kernel/power/snapshot.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > --- linux.orig/kernel/power/snapshot.c
> > +++ linux/kernel/power/snapshot.c
> > @@ -233,7 +233,7 @@ static void *chain_alloc(struct chain_al
> >  
> >  #define BM_END_OF_MAP	(~0UL)
> >  
> > -#define BM_BITS_PER_BLOCK	(PAGE_SIZE << 3)
> > +#define BM_BITS_PER_BLOCK	(PAGE_SIZE * BITS_PER_BYTE)
> >  
> >  struct bm_block {
> >  	struct list_head hook;	/* hook into a list of bitmap blocks */
> > @@ -275,7 +275,7 @@ static void memory_bm_free(struct memory
> >  
> >  /**
> >   *	create_bm_block_list - create a list of block bitmap objects
> > - *	@nr_blocks - number of blocks to allocate
> > + *	@pages - number of pages to track
> >   *	@list - list to put the allocated blocks into
> >   *	@ca - chain allocator to be used for allocating memory
> >   */

BTW:
kernel-doc uses @parameter:
and not         @parameter -

---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
