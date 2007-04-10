Return-Path: <linux-kernel-owner+w=401wt.eu-S1161115AbXDJXqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161115AbXDJXqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 19:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161121AbXDJXqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 19:46:08 -0400
Received: from smtp.osdl.org ([65.172.181.24]:52489 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161115AbXDJXqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 19:46:04 -0400
Date: Tue, 10 Apr 2007 16:45:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, npiggin@suse.de,
       WU Fengguang <wfg@mail.ustc.edu.cn>
Subject: Re: [PATCH] Improve heuristic detecting sequential reads
Message-Id: <20070410164540.6d10ddd7.akpm@linux-foundation.org>
In-Reply-To: <p73y7kzj0ss.fsf@bingen.suse.de>
References: <20070410155411.GF13445@duck.suse.cz>
	<p73y7kzj0ss.fsf@bingen.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Apr 2007 00:56:51 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Jan Kara <jack@suse.cz> writes:
> 
> >   Hello!
> > 
> >   In thread http://lkml.org/lkml/2007/3/9/403, we discussed a problem
> > with the current heuristic for detecting sequential IO in
> > do_generic_mapping_read() - for small files a page is marked as accessed
> > only once which can cause a performance problems.
> >   Attached is a patch that improves the heuristic by introducing a
> > ra.offset variable so now we can reliably detect sequetial reads.
> > The patch replaces Nick's patch from http://lkml.org/lkml/2007/3/15/177
> > (Nick has acked to replace the patch). Could you please put the patch
> > into -mm?
> 
> There's a much more complete patchkit for this that gets reposted
> regularly on l-k. Perhaps it would make sense to test that first?

adaptive readahead?  Has been in -mm for a year.  Problem is, it is
_so_ complete that I just don't know how to merge it.  It's huge, and
only Wu understands it. So it's really rather stuck.
