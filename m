Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZLARMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZLARMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbZLARMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:12:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55943 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbZLARMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:12:16 -0500
Date: Tue, 1 Dec 2009 18:11:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       steved@redhat.com, jens.axboe@oracle.com, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org,
       cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org
Subject: Re: [PATCH] SLOW_WORK: Move slow_work's proc file to debugfs
Message-ID: <20091201171147.GB4699@elte.hu>
References: <6941.1259681771@redhat.com>
 <20091201161455.GB24897@elte.hu>
 <alpine.LFD.2.00.0912010821170.2872@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912010821170.2872@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 1 Dec 2009, Ingo Molnar wrote:
> > 
> > Nice - thanks for doing this so quickly! It might sound like nitpicking 
> > but /proc ABIs tend to be a lot harder to get rid of than debugfs 
> > interfaces.
> 
> Ok, I applied it, so we'll not switch interfaces (even if they are 
> just for debugging) across releases.

I gave it some testing as well on the tree you pushed out - there's no 
failures on x86 nor on any of the non-x86 cross-builds i tried.

Thanks,

	Ingo
