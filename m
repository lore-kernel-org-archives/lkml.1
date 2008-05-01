Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbYEAGP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbYEAGP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 02:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYEAGPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 02:15:20 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35709 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbYEAGPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 02:15:20 -0400
Date: Thu, 1 May 2008 08:15:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, torvalds@linux-foundation.org,
       rjw@sisk.pl, davem@davemloft.net, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, mingo@elte.hu
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <20080430151007.0ace4fa2.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.1.10.0805010812360.5623@fbirervta.pbzchgretzou.qr>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302136.58005.rjw@sisk.pl> <20080430131537.1f7a0914.akpm@linux-foundation.org> <alpine.LFD.1.10.0804301325260.2980@woody.linux-foundation.org> <20080430135405.ddc42075.akpm@linux-foundation.org>
 <4818E7E3.7080705@gmail.com> <20080430151007.0ace4fa2.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thursday 2008-05-01 00:10, Andrew Morton wrote:
>> 
>> Andrew, the latter thing is a very good point. For me personally, the fact
>> that -mm is not available via git is the major obstacle for trying your
>> tree more frequently than just a few times per year.
>
>Every -mm release if available via git://, as described in the release
>announcements.
[...]
>> How difficult it
>> would be to switch to git for you?
>
>Fatal, I expect.  A tool which manages source-code files is just the wrong
>paradigm.  I manage _changes_ against someone else's source files.

Would you mind using stgit? That you way have the queue patch
functionality, yet a simple git-push -f will send the whole
patch stack over to a repo (without the stgit bits that is),
leaving what looks like a regular tree with just lots of
recent commits. Does not even need extra scripts to do a
patchset->git conversion.

>> For busy (or lazy) people like myself, the big problem with linux-next are
>> the frequent merge breakages, when pulling the tree stops with "you are in
>> the middle of a merge conflict".
>
>Really?  Doesn't Stephen handle all those problems?  It should be a clean
>fetch each time?

Indeed, assuming the remote is set up and you have a local branch,
`git reset --hard mm/master` after a fetch is the thing.
But be sure not to have any changed files.
