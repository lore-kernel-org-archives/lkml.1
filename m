Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYHKWCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYHKWCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbYHKWCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:02:34 -0400
Received: from tundra.namei.org ([65.99.196.166]:48340 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbYHKWCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:02:34 -0400
Date: Tue, 12 Aug 2008 07:53:40 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Steve French <sfrench@us.ibm.com>
Subject: Re: Resolved merge conflicts in next-creds
In-Reply-To: <20080811153536.02ac0561.sfr@canb.auug.org.au>
Message-ID: <alpine.LRH.1.10.0808120751001.10017@tundra.namei.org>
References: <alpine.LRH.1.10.0808110950530.3636@tundra.namei.org> <20080811101602.09555609.sfr@canb.auug.org.au> <20080811153536.02ac0561.sfr@canb.auug.org.au>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008, Stephen Rothwell wrote:

> Hi David, James,
> 
> On Mon, 11 Aug 2008 10:16:02 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > I have a plan for getting rid of these - I will start on it today or
> > tomorrow.
> 
> As a start, can you create a patch (or patches) that does just the
> include/linux/creds.h part of commits
> 785af0f385cd424d4b40908bf0e467df3dc05434 ("CRED: Change current->fs[ug]id
> to current_fs[ug]id()") and f4d399d40debd14b22967153294b94087cbcf789
> ("CRED: Wrap most current->e?[ug]id and some task->e?[ug]id") and send
> that to Linus explaining to him the reason we want these in 2.6.27
> (Something like "The introduction of the credentials API in 2.6.28
> requires the abstracting of access to some fields in the task structure.
> This change introduces trivial noop version of the desired accessors so
> that other subsystems can start to be converted over.").  This
> explanation should go in the commit message.
> 
> After he has put those patch(es) in, you could break up the rest of those
> two commits by subsystem/arc/driver (or something) and ask the
> appropriate maintainers to apply them and send them to Linus (with a
> similar explanation) (or just ask them to ACK such patches so you can
> send them upstream).
> 
> Hopefully this way ww will avoid a lot of the merge pain during the next
> merge window and the other subsystems can continue on in their
> development.
> 
> How does that sound?

We have tried this approach thus far without success, although perhaps now 
the code has been in linux-next and you've come to the same conclusion, we 
could try again.

David, if you want to make a minimal API-only patch set, I'll can stage it 
and push to Linus.


- James
-- 
James Morris
<jmorris@namei.org>
