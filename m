Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbYBSHHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbYBSHHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 02:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761067AbYBSHGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 02:06:54 -0500
Received: from mga10.intel.com ([192.55.52.92]:29894 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760914AbYBSHGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 02:06:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,375,1199692800"; 
   d="scan'208";a="299772692"
Subject: Re: NULL pointer in kmem_cache_alloc with 2.6.25-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0802150839180.12023@schroedinger.engr.sgi.com>
References: <1203058021.3027.143.camel@ymzhang>
	 <Pine.LNX.4.64.0802150839180.12023@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 19 Feb 2008 15:03:14 +0800
Message-Id: <1203404594.3248.32.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-15 at 08:42 -0800, Christoph Lameter wrote:
> On Fri, 15 Feb 2008, Zhang, Yanmin wrote:
> 
> > On my 16-core tigerton, kernel panic when I ran hackbench process testing. See
> > below log.
> > 
> 
> > Kernel panic at line 1637 in file mm/slub.c because object=c->freelist=NULL.
> 
> Hmmmm. freelist should never be NULL. Could you rerun the test and boot with 
> slub_debug to make sure that there is no memory corruption?
1) Without slub_debug option, sometime I could trigger it, sometimes not.
2) With slub_debug option, or just enable debug for slab skbuff_fclone_cache
and skbuff_head_cache, I couldn't trigger it.

I will do more testing and investigation, as the bug also exists in 2.6.25-rc2.

-yanmin


