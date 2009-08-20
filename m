Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbZHTBic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbZHTBic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 21:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbZHTBi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 21:38:29 -0400
Received: from rtr.ca ([76.10.145.34]:49781 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbZHTBi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 21:38:27 -0400
Message-ID: <4A8CA913.7020902@rtr.ca>
Date: Wed, 19 Aug 2009 21:38:27 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Jamie Lokier <jamie@shareable.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, xfs@oss.sgi.com,
       linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH, RFC] xfs: batched discard support
References: <20090816004705.GA7347@infradead.org> <20090819203916.GA25296@elte.hu> <20090820010552.GA22107@infradead.org> <20090820011004.GC14005@shareable.org>
In-Reply-To: <20090820011004.GC14005@shareable.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
..
> I don't remember - does TRIM guarantee the blocks read zeros afterwards?
..

No, it doesn't.

A drive can optionally support "deterministic TRIM", whereby it will return
consistent data for any given trimmed sector afterwards, but that doesn't mean zeros.

-ml
