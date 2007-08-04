Return-Path: <linux-kernel-owner+w=401wt.eu-S1765022AbXHDR1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765022AbXHDR1T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 13:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763936AbXHDR1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 13:27:10 -0400
Received: from mail.clusterfs.com ([74.0.229.162]:48223 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761273AbXHDR1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 13:27:09 -0400
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18100.46804.731940.246225@gargle.gargle.HOWL>
Date: Sat, 4 Aug 2007 21:26:44 +0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
In-Reply-To: <20070804094119.81d8e533.akpm@linux-foundation.org>
References: <20070803123712.987126000@chello.nl>
	<alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
	<20070804063217.GA25069@elte.hu>
	<20070804070737.GA940@elte.hu>
	<20070804103347.GA1956@elte.hu>
	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
	<20070804094119.81d8e533.akpm@linux-foundation.org>
X-Mailer: VM 7.17 under 21.5 (patch 28) "fuki" XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

[...]

 > 
 > It's pretty much unfixable given the ext3 journalling design, and the
 > guarantees which data-ordered provides.

ZFS has intent log to handle this
(http://blogs.sun.com/realneel/entry/the_zfs_intent_log). Something like
that can --theoretically-- be added to ext3-style journalling.

Nikita.

 > 
 > The easy preventive is to mount with data=writeback.  Maybe that should
 > have been the default.

