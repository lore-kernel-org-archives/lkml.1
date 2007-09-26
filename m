Return-Path: <linux-kernel-owner+w=401wt.eu-S1762911AbXIZVGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762911AbXIZVGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762724AbXIZVF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:05:56 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33781 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762768AbXIZVFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:05:54 -0400
Subject: Re: [PATCH] JBD/ext34 cleanups: convert to kzalloc
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070926125440.36c3cb5b.akpm@linux-foundation.org>
References: <1189796027.3841.6.camel@localhost.localdomain>
	 <1190057391.3845.22.camel@localhost.localdomain>
	 <1190066466.31220.5.camel@dyn9047017100.beaverton.ibm.com>
	 <1190069851.6725.6.camel@localhost.localdomain>
	 <20070918090407.GA671@infradead.org>
	 <1190133347.3819.6.camel@localhost.localdomain>
	 <1190138690.6528.23.camel@norville.austin.ibm.com>
	 <1190163601.3819.15.camel@localhost.localdomain>
	 <20070918191920.a2130a3c.akpm@linux-foundation.org>
	 <1190229352.4318.12.camel@localhost.localdomain>
	 <20070919194813.GT32520@schatzie.adilger.int>
	 <1190239431.4318.34.camel@localhost.localdomain>
	 <1190416436.11349.13.camel@localhost.localdomain>
	 <20070926125440.36c3cb5b.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Wed, 26 Sep 2007 14:05:51 -0700
Message-Id: <1190840751.4517.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-26 at 12:54 -0700, Andrew Morton wrote:
> On Fri, 21 Sep 2007 16:13:56 -0700
> Mingming Cao <cmm@us.ibm.com> wrote:
> 
> > Convert kmalloc to kzalloc() and get rid of the memset().
> 
> I split this into separate ext3/jbd and ext4/jbd2 patches.  It's generally
> better to raise separate patches, please - the ext3 patches I'll merge
> directly but the ext4 patches should go through (and be against) the ext4
> devel tree.
> 
Sure. The patches(including ext3/jbd and ext4/jbd2) were merged into
ext4 devel tree already, I will remove the ext3/jbd part out of the ext4
devel tree.

> I fixed lots of rejects against the already-pending changes to these
> filesystems.
> 
> You forgot to remove the memsets in both start_this_handle()s.
> 
Thanks for catching this.

Mingming

