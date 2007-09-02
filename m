Return-Path: <linux-kernel-owner+w=401wt.eu-S965501AbXIBLkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965501AbXIBLkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 07:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbXIBLk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 07:40:27 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58324 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755702AbXIBLkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 07:40:25 -0400
Date: Sun, 2 Sep 2007 04:40:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Christoph Hellwig <hch@infradead.org>
cc: Mingming Cao <cmm@us.ibm.com>, linux-fsdevel@vger.kernel.org,
       adilger@clusterfs.com, sho@tnes.nec.co.jp,
       ext4 development <linux-ext4@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] JBD: slab management support for large block(>8k)
In-Reply-To: <20070901183922.GA12907@infradead.org>
Message-ID: <Pine.LNX.4.64.0709020438490.28046@schroedinger.engr.sgi.com>
References: <20070828190551.415127746@sgi.com> <20070828190735.292638294@sgi.com>
 <1188432669.3799.35.camel@localhost.localdomain> <1188434857.3799.76.camel@localhost.localdomain>
 <1188605538.3837.51.camel@localhost.localdomain> <20070901183922.GA12907@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Sep 2007, Christoph Hellwig wrote:

> On Fri, Aug 31, 2007 at 05:12:18PM -0700, Mingming Cao wrote:
> > >From clameter:
> > Teach jbd/jbd2 slab management to support >8k block size. Without this, it refused to mount on >8k ext3.
> 
> 
> But the real fix is to kill this code.  We can't send down slab pages
> down the block layer without breaking iscsi or aoe.  And this code is
> only used in so rare cases that all the normal testing won't hit it.
> Very bad combination.

We are doing what you describe right now. So the current code is broken?


