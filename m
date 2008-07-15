Return-Path: <linux-kernel-owner+w=401wt.eu-S1758139AbYGOXK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbYGOXK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 19:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbYGOXKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 19:10:48 -0400
Received: from r00tworld.com ([212.85.137.21]:45988 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbYGOXKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 19:10:47 -0400
From: pageexec@freemail.hu
To: Greg KH <greg@kroah.com>
Date: Wed, 16 Jul 2008 01:09:20 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <487D4A40.8310.1C7356A7@pageexec.freemail.hu>
In-reply-to: <20080715223910.GA6500@kroah.com>
References: <20080715183351.GF8185@mit.edu>, <487D249C.19043.1BE04D4D@pageexec.freemail.hu>, <20080715223910.GA6500@kroah.com>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 16 Jul 2008 01:10:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Jul 2008 at 15:39, Greg KH wrote:

> On Tue, Jul 15, 2008 at 10:28:44PM +0200, pageexec@freemail.hu wrote:
> > Ted, the discussion is *not* about what the best disclosure policy
> > would be for the kernel. the problem i raised was that there's one
> > declared policy in Documentation/SecurityBugs (full disclosure) yet
> > actual actions are completely different and now Linus even admitted
> > it.
> 
> Huh?
> 
> How does what is described there differ from what Linus said,

read his mails and my responses, it's all in there. basically, he said
so himself that he knowingly withholds information. no matter how you spin
that, that's not full disclosure. note that i'm not advocating for using
that disclosure policy for kernel bugs, it's what *you* guys chose and
i'm just asking why you're not practicing it. you're also free to change
to something else, just don't forget to tell the world about it.

> or the -stable team has been doing so far?
> 
> What specifically are you asking for that is different?

that doc says full disclosure, it doesn't say 'but withholding this
or that'. if you don't know what 'full disclosure' means then you're
welcome to ask on proper security mailing lists such as bugtraq or
dailydave or, why not, the list named after this very policy.

> The -stable commits are exactly the same as they are in mainline
> (Linus's tree).  Are you upset by the fact that I am not saying, "Hey,
> look, here's a bugfix that might be security related

yes, you should include that at least. i didn't say that btw, your fellow
-stable maintainer did:

  Had I realized there was a security issue, I would highlight it in the
  announce message.  In fact, that's our standard procedure for -stable.
  (http://lkml.org/lkml/2008/6/10/328)

the 2.4 maintainer agreed with him:

  I don't like obfuscation at all WRT security issues, it does far more
  harm than good because it reduces the probability to get them picked
  and fixed by users, maintainers, distro packagers, etc...
  (http://lkml.org/lkml/2008/6/10/452)

i think you're outgunned here Greg. and no, i'm not upset (after all, i'm
the one catching you cover up security bugs, right? you're not hurting me),
but more and more of your users are.

> and here's how to reproduce it!" in big flashing letters?

no, that doesn't really belong there but it's a nice addition for certain
people.

Greg, instead of pretending to be surprised and upset or whatever, go
read the whole thread first.

cheers,
  PaX Team

