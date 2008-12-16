Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbYLPGiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbYLPGiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 01:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYLPGiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 01:38:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47664
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbYLPGiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 01:38:09 -0500
Date: Mon, 15 Dec 2008 22:38:10 -0800 (PST)
Message-Id: <20081215.223810.262172290.davem@davemloft.net>
To: adobriyan@gmail.com
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       mingo@elte.hu, akpm@linux-foundation.org, acme@ghostprotocols.net
Subject: Re: Impact:
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081216011039.GA2458@x200.localdomain>
References: <alpine.DEB.1.10.0812101504280.11805@gandalf.stny.rr.com>
	<20081215.002019.232912990.davem@davemloft.net>
	<20081216011039.GA2458@x200.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Tue, 16 Dec 2008 04:10:39 +0300

> On Mon, Dec 15, 2008 at 12:20:19AM -0800, David Miller wrote:
> > >     update rwlock initialization for nat_table
> > >     
> > >     Impact: clean up
> > >     
> > >     The commit e099a173573ce1ba171092aee7bb3c72ea686e59
> > >     (netfilter: netns nat: per-netns NAT table) renamed the
> > >     nat_table from __nat_table to nat_table without updating the
> > >     __RW_LOCK_UNLOCKED(__nat_table.lock).
> > >     
> > >     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > 
> > Applied to net-2.6, thanks Steven.
> > 
> > As Andrew mentioned this is a bug (albeit a "nano-bug" as you
> > called it :-) so I removed the Impact line in the commit
> > message when applying this.
> 
> Speaking of Impact: lines, is this a new fashion or what?

I don't know what it is, but I find them pointless.

Just provide a proper verbose commit message and be done with it.

At the rate we're going we'll soon have commit messages like:

--------------------
Impact: Crashes kernel
Cause: Race between timer and workqueue
Implementation: ...
--------------------

I mean, spare me...
