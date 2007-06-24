Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbXFXUii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbXFXUii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbXFXUia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:38:30 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:51972 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbXFXUi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:38:29 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
Date: Sun, 24 Jun 2007 20:35:35 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f5mkin$29j$1@taverner.cs.berkeley.edu>
References: <466C303E.5010304@novell.com> <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1182717335 2355 128.32.168.222 (24 Jun 2007 20:35:35 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sun, 24 Jun 2007 20:35:35 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley  wrote:
>On Thu, 2007-06-21 at 21:54 +0200, Lars Marowsky-Bree wrote:
>> And now, yes, I know AA doesn't mediate IPC or networking (yet), but
>> that's a missing feature, not broken by design.
>
>The incomplete mediation flows from the design, since the pathname-based
>mediation doesn't generalize to cover all objects unlike label- or
>attribute-based mediation.

I don't see anything in the AA design that would prevent an extending
it to mediate network and IPC while remaining consistent with its design
so far.  Do you?  It seems to me the AA design is to mediate filesystem
access using pathname-based access control, and that says nothing about
how they mediate network access.

I have built sandboxing tools before, and my experience is that the
filesystem mediation is the hardest, gronkiest part.  In comparison,
mediating networking and IPC is considerably easier.  The policy
language for mediating access to the network can be pretty simple.
The same for IPC.  Obviously you shouldn't expect the policy language
for networking to use filenames, any more than you should expect the
policy languages for filesystems to use TCP/IP port numbers; that wouldn't
make any sense.


>And the "use the natural abstraction for
>each object type" approach likewise doesn't yield any general model or
>anything that you can analyze systematically for data flow.

I don't see this as relevant to whether AA should be merged.
Fight that one in the marketplace for users, not L-K.

>> If I restrict my Mozilla to not access my on-disk mail folder, it can't
>> get there. (Barring bugs in programs which Mozilla is allowed to run
>> unconfined, sure.)
>
>Um, no.  It might not be able to directly open files via that path, but
>showing that it can never read or write your mail is a rather different
>matter.

"Showing that it can never read or write your mail" is not part of AA's
goals.  People whose goals differ from AA's can use a different tool.
No one is forcing you to use AA if it isn't useful to you.

I don't see this criticism as relevant to a merger decision.
