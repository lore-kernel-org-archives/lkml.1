Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbZFCDmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbZFCDmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 23:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbZFCDmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 23:42:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43015 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbZFCDme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 23:42:34 -0400
Date: Tue, 2 Jun 2009 23:42:33 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Theodore Tso <tytso@mit.edu>
cc: Dan Magenheimer <dan.magenheimer@oracle.com>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <20090603024311.GZ31943@mit.edu>
Message-ID: <alpine.DEB.2.00.0906022332230.14994@gandalf.stny.rr.com>
References: <20090602232843.GA6577@elte.hu> <793c2ffe-16d3-4e6c-9cd2-32fa089e46a3@default> <20090603024311.GZ31943@mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2 Jun 2009, Theodore Tso wrote:

> On Tue, Jun 02, 2009 at 05:00:21PM -0700, Dan Magenheimer wrote:
> > That sound you heard was 10000 xen-users@lists.xensource.com
> > all having heart attacks at once.
> > 
> > Need I say more.
> 
> So maybe I'm stupid, but why would they be having heart attacks?

Maybe because they asked for an apple and got an apple pie?

That is, they are pushing hard for an interface for Dom0, and Ingo just 
agreed to take it along with the entire Xen hypervisor ;-)

> 
> It seems like a decent solutoin to me.  What's being proposed would
> make the dom0/hypervisor interface an internal once, always subject to
> change.  What's wrong with that?  Presumably the domU/hypervisor
> interface would have to be remain stable, but why is the
> dom0/hypervisor interface have to be sacred and unchanging?  I don't
> understand the concern.

I know I said it was a crazy idea, but the craziness was not with the 
technical side, or even if it is the correct thing to do. I just don't see 
the Xen team cooperating with the Linux team. But maybe those are the old 
days. Perhaps the rightful place for the Xen hypervisor is in Linux. Xen 
is GPL right? Thus we could do this even with out the permission from 
Citrix.

The Dom0 push of Xen just seems too much like Linux being Xen's sex 
slave, when it should be the other way around. By Linux acquiring the Xen 
hypervisor, then I can imaging much more progress in the area of Xen. KVM 
may be a competitor, but the two may also be able to share code thus both 
could benefit.

I'm not as turned off by Paravirt as others (although I've had my cursing 
at it), but with Xen inside Linux, we can tame the damage. Progress of Xen 
would speed up since there would be no barrier with the changes in Linux 
with the changes in Xen. That is, they will always be compatible.

-- Steve

