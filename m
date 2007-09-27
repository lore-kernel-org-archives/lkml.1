Return-Path: <linux-kernel-owner+w=401wt.eu-S1759615AbXI0WHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615AbXI0WHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 18:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbXI0WHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 18:07:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47563 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbXI0WHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 18:07:35 -0400
Subject: Re: [RFC][PATCH] make reiserfs stop using 'struct file' for
	internal xattr operations
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <haveblue@us.ibm.com>, hch@infradead.org,
       laurent.riffard@free.fr, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-devel@vger.kernel.org
In-Reply-To: <20070927145125.1346901f.akpm@linux-foundation.org>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
	 <46FC021F.8060109@free.fr>
	 <20070927124833.d2691813.akpm@linux-foundation.org>
	 <20070927202607.GA3812@infradead.org> <1190926419.7344.27.camel@localhost>
	 <20070927210423.GA6117@infradead.org> <1190928434.7344.31.camel@localhost>
	 <20070927145125.1346901f.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 00:02:53 +0200
Message-Id: <1190930574.18147.60.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-09-27 at 14:51 -0700, Andrew Morton wrote:

> So your stuff becomes dependent on Nick's stuff, and Nick's stuff is still
> failing on NFS, I think.

It worked today, it turned out to be a UML bug. Real hardware seemed to
work properly, but will test a bit more tomorrow.

