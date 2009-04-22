Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZDVFlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZDVFlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 01:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbZDVFlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 01:41:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33611 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbZDVFlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 01:41:04 -0400
Date: Wed, 22 Apr 2009 07:41:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Tejun Heo <tj@kernel.org>,
       Daniel Collins <solemnwarning@solemnwarning.no-ip.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] [PATCH] block: include empty disks in /proc/diskstats
Message-ID: <20090422054103.GS4593@kernel.dk>
References: <49E13D18.2090805@solemnwarning.net> <49E440D9.4020803@kernel.org> <49E45079.8070508@kernel.org> <20090421215401.GA24073@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421215401.GA24073@hera.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21 2009, Chris Wright wrote:
> * Tejun Heo (tj@kernel.org) wrote:
> > /proc/diskstats used to show stats for all disks whether they're
> > zero-sized or not and their non-zero partitions.  Commit
> > 074a7aca7afa6f230104e8e65eba3420263714a5 accidentally changed the
> > behavior such that it doesn't print out zero sized disks.  This patch
> > implements DISK_PITER_INCL_EMPTY_PART0 flag to partition iterator and
> > uses it in diskstats_show() such that empty part0 is shown in
> > /proc/diskstats.
> > 
> > Reported and bisectd by Dianel Collins.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-by: Daniel Collins <solemnwarning@solemnwarning.no-ip.org>
> 
> looks like this isn't upstream yet.

It'll go upstream today or tomorrow.

-- 
Jens Axboe

