Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbYGPJfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbYGPJfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 05:35:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbYGPJfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 05:35:00 -0400
Received: from r00tworld.com ([212.85.137.21]:47382 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbYGPJe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 05:34:59 -0400
From: pageexec@freemail.hu
To: Tiago Assumpcao <tiago@assumpcao.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Date: Wed, 16 Jul 2008 11:33:12 +0200
MIME-Version: 1.0
Subject: Re: [stable] Linux 2.6.25.10
Reply-to: pageexec@freemail.hu
CC: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Message-ID: <487DDC78.2960.1EAE7F08@pageexec.freemail.hu>
In-reply-to: <487D6AB9.7080700@schaufler-ca.com>
References: <alpine.LFD.1.10.0807151425170.2867@woody.linux-foundation.org>, <487D547C.7060909@assumpcao.org>, <487D6AB9.7080700@schaufler-ca.com>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Wed, 16 Jul 2008 11:33:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Jul 2008 at 20:27, Casey Schaufler wrote:

> Tiago Assumpcao wrote:
> > Theodore Tso wrote:
> >> Look if you want this, pay $$$ to a distribution and get their
> >> supported distribution.  It costs time and effort to classify bugs as
> >> security related (or not), (...)
> >
> > That's fallacious. Assuming that you have good programmers, and you 
> > do, it's of very low cost the act of identifying what *is likely to 
> > be* a security bug.
> 
> That is based on lots and lots of assumptions that are just not true.
> Ted Tso, Stephen Smalley and I are all recognized as security experts

not so quick. security is a big field, noone really can claim to be
a general expert. Ted knows kerberos but he would be unable to exploit
the task refcount leak bug fixed in 2.6.25.10. Stephen and you know
MAC systems inside out but you too would be unable to exploit that bug.
different domains, different expertise, despite all being 'security'.
with that foreword:

> and we can't even agree on whether sockets are objects or not,

and it's utterly irrelevant to the next hacker that will own your precious
MAC by exploiting a kernel bug that you 'experts' didn't deem important
enough to tell the world about. do you understand that we've been talking
about *kernel* bugs here? do you understand what privilege elevation is?
you surely do since you work with MAC systems all the time whose purpose
is, well, access control.

> much less what constitutes a security bug and even less what is likely to
> be a security bug.

privilege elevation bugs are security bugs, no ifs and buts. whether a given
bug can be exploited at that level is a different question, and if you can't
make that judgement you're welcome to err on the side of safety (i.e., have
people upgrade/backport rather than be possibly exposed) or bring in help
(if Microsoft can pay people to do that, so can commercial Linux companies).

> Goodness, there are some of us who would argue
> that since DNS is itself a security bug it is just not possible for
> DNS to have a security bug, as an example.

it's all very much irrelevant to local kernel security that we're talking
about.
 
> > In most cases, they are easy to spot.
> 
> Err, no, in the kernel environment a real security flaw is likely to
> be pretty subtle.

i don't have stats about 'most' vs 'likely', but yes, they can indeed
be subtle, that's why you should not be overly optimistic and dismiss
potentially exploitable bugs as not relevant and cover them up.

cheers,
  PaX Team

