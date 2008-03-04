Return-Path: <linux-kernel-owner+w=401wt.eu-S1763659AbYCDSPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763659AbYCDSPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbYCDSPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:15:00 -0500
Received: from brick.kernel.dk ([87.55.233.238]:17337 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbYCDSO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:14:59 -0500
Date: Tue, 4 Mar 2008 19:14:54 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       ISS StorageDev <iss_storagedev@hp.com>
Subject: Re: 2.6.25-rc3-mm1 (CCISS)
Message-ID: <20080304181453.GO6704@kernel.dk>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <20080304084557.357972a3.randy.dunlap@oracle.com> <DEE40752C8AF224BB890E455C7B8E0FE042B764935@G6W0268.americas.hpqcorp.net> <47CD8391.2040101@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CD8391.2040101@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04 2008, Randy Dunlap wrote:
> Miller, Mike (OS Dev) wrote:
> >Randy wrote:
> >>On Tue, 4 Mar 2008 01:19:28 -0800 Andrew Morton wrote:
> >>
> >>>
> >>ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-r
> >>>c3/2.6.25-rc3-mm1/
> >>With
> >>CONFIG_BLK_CPQ_DA=m
> >>CONFIG_BLK_CPQ_CISS_DA=m
> >># CONFIG_CISS_SCSI_TAPE is not set
> >>
> >>I'm getting
> >>In file included from drivers/block/cciss.c:230:
> >>drivers/block/cciss_scsi.c:1498:38: error: macro parameters
> >>must be comma-separated
> >>drivers/block/cciss.c: In function 'cciss_seq_show_header':
> >>drivers/block/cciss.c:271: error: implicit declaration of
> >>function 'cciss_seq_tape_report'
> >>drivers/block/cciss.c: In function 'cciss_proc_write':
> >>drivers/block/cciss.c:392: error: implicit declaration of
> >>function 'cciss_engage_scsi'
> >>make[2]: *** [drivers/block/cciss.o] Error 1
> >>make[1]: *** [drivers/block] Error 2
> >>make[1]: *** Waiting for unfinished jobs....
> >>
> >>---
> >Randy,
> >It looks like you have the original broken patch. I resubmitted and I 
> >think Jens picked up the fixed patch but I don't know where it is...  :(
> 
> s/you/latest -mm/
> 
> I thought that this had been fixed, but I can't find it either... :(
> 
> Jens, did you queue a patch for this?

I did, here:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=89b6e743788516491846724d7ef89bcac7ac9c99

-- 
Jens Axboe

