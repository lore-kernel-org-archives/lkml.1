Return-Path: <linux-kernel-owner+w=401wt.eu-S1753094AbZFCCob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbZFCCob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 22:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZFCCoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 22:44:22 -0400
Received: from thunk.org ([69.25.196.29]:37348 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbZFCCoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 22:44:22 -0400
Date: Tue, 2 Jun 2009 22:43:11 -0400
From: Theodore Tso <tytso@mit.edu>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, avi@redhat.com,
       xen-devel@lists.xensource.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, Keir Fraser <Keir.Fraser@eu.citrix.com>,
       torvalds@linux-foundation.org, gregkh@suse.de, kurt.hackel@oracle.com,
       Ian Pratt <Ian.Pratt@eu.citrix.com>, xen-users@lists.xensource.com,
       ksrinivasan <ksrinivasan@novell.com>, EAnderson@novell.com,
       wimcoekaerts@wimmekes.net, Stephen Spector <stephen.spector@citrix.com>,
       jens.axboe@oracle.com, npiggin@suse.de
Subject: Re: Merge Xen (the hypervisor) into Linux
Message-ID: <20090603024311.GZ31943@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Dan Magenheimer <dan.magenheimer@oracle.com>,
	Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
	George Dunlap <george.dunlap@eu.citrix.com>,
	David Miller <davem@davemloft.net>, jeremy@goop.org, avi@redhat.com,
	xen-devel@lists.xensource.com, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Keir Fraser <Keir.Fraser@eu.citrix.com>,
	torvalds@linux-foundation.org, gregkh@suse.de,
	kurt.hackel@oracle.com, Ian Pratt <Ian.Pratt@eu.citrix.com>,
	xen-users@lists.xensource.com, ksrinivasan <ksrinivasan@novell.com>,
	EAnderson@novell.com, wimcoekaerts@wimmekes.net,
	Stephen Spector <stephen.spector@citrix.com>, jens.axboe@oracle.com,
	npiggin@suse.de
References: <20090602232843.GA6577@elte.hu> <793c2ffe-16d3-4e6c-9cd2-32fa089e46a3@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <793c2ffe-16d3-4e6c-9cd2-32fa089e46a3@default>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 05:00:21PM -0700, Dan Magenheimer wrote:
> That sound you heard was 10000 xen-users@lists.xensource.com
> all having heart attacks at once.
> 
> Need I say more.

So maybe I'm stupid, but why would they be having heart attacks?

It seems like a decent solutoin to me.  What's being proposed would
make the dom0/hypervisor interface an internal once, always subject to
change.  What's wrong with that?  Presumably the domU/hypervisor
interface would have to be remain stable, but why is the
dom0/hypervisor interface have to be sacred and unchanging?  I don't
understand the concern.

			       	     	    - Ted
