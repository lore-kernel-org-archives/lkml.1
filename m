Return-Path: <linux-kernel-owner+w=401wt.eu-S1759917AbXI0Vz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917AbXI0Vz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 17:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757492AbXI0VzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 17:55:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49485 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755659AbXI0VzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 17:55:10 -0400
Date: Thu, 27 Sep 2007 14:54:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: haveblue@us.ibm.com, hch@infradead.org, laurent.riffard@free.fr,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       reiserfs-devel@vger.kernel.org
Subject: Re: [RFC][PATCH] make reiserfs stop using 'struct file' for
 internal xattr operations
Message-Id: <20070927145423.32ae6d1c.akpm@linux-foundation.org>
In-Reply-To: <20070927145125.1346901f.akpm@linux-foundation.org>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
	<46FC021F.8060109@free.fr>
	<20070927124833.d2691813.akpm@linux-foundation.org>
	<20070927202607.GA3812@infradead.org>
	<1190926419.7344.27.camel@localhost>
	<20070927210423.GA6117@infradead.org>
	<1190928434.7344.31.camel@localhost>
	<20070927145125.1346901f.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 14:51:25 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > Plus, reiserfs seems to compile with that patch I just sent.  Sure as
> > heck surprised me.
> > 
> 
> That'll be because reiserfs-convert-to-new-aops.patch witched reiserfs over
> to ->write_begin() and ->write_end().

Actually, we should rename reiserfs_prepare_write and reiserfs_commit_write
to something else to reduce confusion.  Probably lots of other filesystems
would benefit from the same change, post-Nick's-stuff.
