Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbZFDTsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbZFDTsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZFDTsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:48:13 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34194 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbZFDTsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:48:12 -0400
Date: Thu, 4 Jun 2009 21:48:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 07/12] writeback: support > 1 flusher thread per bdi
Message-ID: <20090604194813.GA11363@kernel.dk>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com> <1243330430-9964-8-git-send-email-jens.axboe@oracle.com> <20090604174439.GF6739@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604174439.GF6739@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04 2009, Paul E. McKenney wrote:
> On Tue, May 26, 2009 at 11:33:45AM +0200, Jens Axboe wrote:
> > Build on the bdi_writeback support by allowing registration of
> > more than 1 flusher thread. File systems can call bdi_add_flusher_task(bdi)
> > to add more flusher threads to the device. If they do so, they must also
> > provide a super_operations function to return the suitable bdi_writeback
> > struct from any given inode.
> 
> Looks good from an RCU perspective.  SRCU used for wb_list, RCU for the
> other RCU-protected data.  ;-)

Great, thanks for reviewing!

-- 
Jens Axboe

