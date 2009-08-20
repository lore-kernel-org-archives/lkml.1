Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869AbZHTBKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbZHTBKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 21:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbZHTBKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 21:10:30 -0400
Received: from mail2.shareable.org ([80.68.89.115]:49996 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbZHTBK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 21:10:29 -0400
Date: Thu, 20 Aug 2009 02:10:04 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com,
       linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com
Subject: Re: [PATCH, RFC] xfs: batched discard support
Message-ID: <20090820011004.GC14005@shareable.org>
References: <20090816004705.GA7347@infradead.org> <20090819203916.GA25296@elte.hu> <20090820010552.GA22107@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820010552.GA22107@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> > So i'm torn about the 'syscall versus ioctl' issue, i'd 
> > like to avoid making interface design mistakes and i'd 
> > like to solicit some opinions about this. I've attached 
> > the perfcounters ioctl patch below.
> 
> Only add a syscall if it has _one_ clear defined purpose,
> which has kernel-wide meaning.

One clear defined purpose which comes to mind is a "trim" or "punch"
system call, for making holes in files as well as trimming block
devices.  Several other OSes have that capability on files.

I don't remember - does TRIM guarantee the blocks read zeros afterwards?

It would be tidy if it does, as it could have the same meaning with files.

-- Jamie

