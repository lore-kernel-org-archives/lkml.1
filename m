Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbXK0Ih1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbXK0Ih1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 03:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751070AbXK0IhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 03:37:17 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:55477 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbXK0IhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 03:37:16 -0500
Date: Tue, 27 Nov 2007 08:36:41 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Pavel Emelyanov <xemul@openvz.org>, Linux MM <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH][SHMEM] Factor out sbi->free_inodes manipulations
In-Reply-To: <20071126212311.88818502.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0711270835170.19731@blonde.wat.veritas.com>
References: <4745B4F2.3060308@openvz.org> <Pine.LNX.4.64.0711231325510.18348@blonde.wat.veritas.com>
 <20071126212311.88818502.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Andrew Morton wrote:
> 
> It is peculair to (wrongly) return -ENOMEM
> 
> > +	if (shmem_reserve_inode(inode->i_sb))
> > +		return -ENOSPC;
> 
> and to then correct it in the caller..

Oops, I missed that completely.

> Something boringly conventional such as the below, perhaps?

Much better, thanks.

Hugh
