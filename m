Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbXJ0Kqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbXJ0Kqk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 06:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbXJ0Kqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 06:46:33 -0400
Received: from doom.schmorp.de ([87.139.53.102]:47600 "EHLO doom.schmorp.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbXJ0Kqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 06:46:32 -0400
Date: Sat, 27 Oct 2007 12:46:28 +0200
From: Marc Lehmann <schmorp@schmorp.de>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Marc Lehmann <linux-kernel@tst.eu>, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>
Subject: Re: epoll design problems with common fork/exec patterns
Message-ID: <20071027104627.GA26748@schmorp.de>
Mail-Followup-To: Eric Dumazet <dada1@cosmosbay.com>,
	Marc Lehmann <linux-kernel@tst.eu>, linux-kernel@vger.kernel.org,
	Davide Libenzi <davidel@xmailserver.org>
References: <20071027062236.GA12476@schmorp.de> <4722F575.8080204@cosmosbay.com> <20071027085125.GC12326@schmorp.de> <47230351.8040100@cosmosbay.com> <20071027093424.GA31329@schmorp.de> <472311B8.5080408@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472311B8.5080408@cosmosbay.com>
X-PGP: "1024D/DA743396 1999-01-26 Marc Alexander Lehmann <schmorp@schmorp.de>
       Key fingerprint = 475A FE9B D1D4 039E 01AC  C217 A1E8 0270 DA74 3396"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 12:23:52PM +0200, Eric Dumazet <dada1@cosmosbay.com> wrote:
> >    Q6     Will the close of an fd cause it to be removed from all epoll 
> >    sets automatically?
> >    A6     Yes.
> 
> Answer : epoll documentation cannot explain the full semantic of file 

epoll documentation easily can. there is nothig keeping it from it. don't
make silly arguments like that.

> Or should, since you had problems

You are again implying I lakc understanding. That is, however, not true.
I don't see the point in being insulted by you, so I won'T continue
talking to you :(

> The 'close' of a file is not close(fd) :)

Good that you understand that.

That is one of my problems, as the manpage talks about closing of the fd,
but there are multiple ways to do that, and some are not handled the same
way.

> epoll has to deal with files, but documentation is a User side 
> documentation, so has to use 'file descriptors'.

There is obviously no need for documentation to do that, contrary to your
claim. The manpages for e.g. dup or the official sus manpages manage to
document it (mostly) correctly, so your claim that documentation must use
file descriptors when the underlying file structure is meant is disproven.

> fork() is acting sort of dup() , as it increases all file refcounts.
> 
> You have problems about close()/dup()/fork()/... file descriptors semantic, 
> which is handled by a layer independent from epoll stuff.

No, I have no problem with dup at all.

I have a problem with explicitlx closing file descriptors in the child will
stop events for those files to be reported in the parent.

I am sorry, but I epxlained this very clearly a number of times, but for some
reason, apart from accusing me to not understanding files and file
descritpors or (clear enough) documentation, you ignore that and instead
hammer on other problems.

To me, it seems you are not the one who understands.

-- 
                The choice of a       Deliantra, the free code+content MORPG
      -----==-     _GNU_              http://www.deliantra.net
      ----==-- _       generation
      ---==---(_)__  __ ____  __      Marc Lehmann
      --==---/ / _ \/ // /\ \/ /      pcg@goof.com
      -=====/_/_//_/\_,_/ /_/\_\
