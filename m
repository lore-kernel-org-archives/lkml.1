Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbYHKVxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbYHKVxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 17:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbYHKVxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 17:53:25 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:37320 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683AbYHKVxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 17:53:23 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon
 access scanning
Date: Mon, 11 Aug 2008 21:53:23 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <g7qccj$6m0$1@taverner.cs.berkeley.edu>
References: <20080806105008.GF6477@cs181140183.pp.htv.fi> <200808111645.48177.mdontu@bitdefender.com> <20080811065608.44687f65@infradead.org> <48A0649B.4010706@sun.com>
Reply-To: daw-news@cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1218491603 6848 128.32.168.222 (11 Aug 2008 21:53:23 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Mon, 11 Aug 2008 21:53:23 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Collier-Brown writes:
>Arjan van de Ven wrote:
>> we do still appreciate your description, since I don't think there's a
>> clear "here's what we really try to protect against" statement yet.
>
>  Perhaps I could try: the AV folks are trying to prevent the
>execution of either modified normal binaries/files or 
>specifically exploit binaries/files, by machines for which the 
>files are executable or interpretable.

1. We already know how to prevent/detect modifications to
normal binaries.  See Tripwire etc.  As far as I know, no new
kernel technology is needed.

2. Preventing execution of exploit binaries/files is not a
well-defined problem, because there is no reliable way to recognize
an exploit binary.  If this is the problem definition, then in
practice it will probably be impossible to meet this goal exactly.
So this sounds like a kind of "aspirational" goal, but presumably
it's not the whole story and it's not a full problem statement, and
we need to know more precisely what the goals do and don't include.
At some point we have to get beyond slogans and philosophies and
move on to specifics.

3. Let me point out that you snipped a key line from Arjan van
de Ven's email:

  Answering Ted's questions would be a really good start...

And in particular you haven't answered Ted's questions.  I agree
with Arjan's email: I think we have to know the answer to Ted's
questions before we can have a meaningful technical discussion.
What's the threat model?  What problem, specifically, are we
trying to solve?  What are the security goals?  Given that there
are no silver bullets and there's no way to stop all attacks, which
class of risks are or aren't in scope?

Bottom line: It's helpful to try to understand each other's point
of view and where we're each coming from, and this may be a start
on that, but I don't think this answers the questions yet.  It seems
like we're still talking past each other.
