Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbYLPBGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbYLPBGS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 20:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYLPBGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 20:06:06 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:32849 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbYLPBGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 20:06:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wKzX7WOhR0rc8WaZ8vV6IIkGuxbGYbDrx/UYiUW8c2s3g6gmfMODfGXNJiycLYKvRx
         DALIxCFCcHF/l/eMA3TefxZkDitKWz6n3ICcWZO/zmQ7n/5A1P99qpteeIHvq2fmKZoN
         mwbqWzrXGK2eIlx9gqW3zSy2arHIT2xm4z5GQ=
Date: Tue, 16 Dec 2008 04:10:39 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       mingo@elte.hu, akpm@linux-foundation.org, acme@ghostprotocols.net
Subject: Impact: (was Re: [PATCH] update rwlock initialization for
	nat_table)
Message-ID: <20081216011039.GA2458@x200.localdomain>
References: <alpine.DEB.1.10.0812101314460.11805@gandalf.stny.rr.com> <49400B7F.7040607@cosmosbay.com> <alpine.DEB.1.10.0812101504280.11805@gandalf.stny.rr.com> <20081215.002019.232912990.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081215.002019.232912990.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 12:20:19AM -0800, David Miller wrote:
> >     update rwlock initialization for nat_table
> >     
> >     Impact: clean up
> >     
> >     The commit e099a173573ce1ba171092aee7bb3c72ea686e59
> >     (netfilter: netns nat: per-netns NAT table) renamed the
> >     nat_table from __nat_table to nat_table without updating the
> >     __RW_LOCK_UNLOCKED(__nat_table.lock).
> >     
> >     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> Applied to net-2.6, thanks Steven.
> 
> As Andrew mentioned this is a bug (albeit a "nano-bug" as you
> called it :-) so I removed the Impact line in the commit
> message when applying this.

Speaking of Impact: lines, is this a new fashion or what?

Looking at the ones which are already in official tree, they are either
trivially duplicating Subject: line, or effectively duplicating Subject: line,
or cover up for insufficiently informative (read: badly written) Subject: line,
or simply useless.


	Subject: sched: CPU remove deadlock fix
	Impact: fix possible deadlock in CPU hot-remove path

What prevented to write "Subject: sched: fix possible deadlock in CPU hot-remove path"?


	AMD IOMMU: __unmap_single: check for bad_dma_address instead of 0
	Impact: minor fix

Well...

I have an idea on how to make them remotely useful, but can we agree that there is
a problem arising here?
