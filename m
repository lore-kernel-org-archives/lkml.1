Return-Path: <linux-kernel-owner+w=401wt.eu-S1031265AbXDQV5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031265AbXDQV5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 17:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031266AbXDQV5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 17:57:53 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:37833 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031265AbXDQV5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 17:57:52 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: AppArmor FAQ
Date: Tue, 17 Apr 2007 21:51:13 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f03fgh$2o1$1@taverner.cs.berkeley.edu>
References: <20070417181016.GA10903@one.firstfloor.org> <657751.18080.qm@web36614.mail.mud.yahoo.com> <20070417211653.GB11944@one.firstfloor.org> <1176846088.5946.62.camel@localhost.localdomain>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1176846673 2817 128.32.168.222 (17 Apr 2007 21:51:13 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Tue, 17 Apr 2007 21:51:13 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karl MacMillan  wrote:
>I don't think that the ease-of-use issue is clear cut. The hard part of
>understanding both SELinux policies and AppArmor profiles is
>understanding what access should be allowed. [...]
>Whether the access is allowed with the SELinux or
>AppArmor language seems like a small issue in comparison. Given that I
>think it is better to choose the solution that is complete and capable
>of meeting the most security concerns.

I have a different reaction.  Given that the ease of use vs
completeness issues are not completely understood, I would think
it would make more sense to include both in the kernel.  Wasn't that
the whole point of the LSM interface, to let competing approaches
bloom and compete on their merits?

I have to say that I'm not convinced the difference in policy
languages is a small issue.  I find the SELinux policy language
and policy files more or less inscrutable.  In comparison, from
the AppArmor FAQ, I can imagine that I might be able to understand
enough to hack AppArmor policies after 5 minutes of reading a
man page.  Whether I'm likely to know what the policy ought to be
is indeed a tough question, but I can imagine that AppArmor might
be more usable than SELinux.  Even if SELinux is more "complete"
than AppArmor, I might still prefer ease of use over completeness
and understandability.

And I have to say that the ability to form a mental model of how
the system works and understand more or less what it is doing may
be useful.  I find debugging SELinux problems a bear: I often just
end up disabling entire SELinux policies, or turning off SELinux,
because I can't understand what it's doing.  In comparison, it's
plausible that it might be easier for sysadmins to understand what
AppArmor is doing, since they don't have to understand labelling and
hard-to-read policy files.  And the increase in understandability
might potentially outweigh the "completeness" issue, in some cases.
Ultimately, easier to use and easier to understand tools might
better solve security overall, because they are more likely to be
used and to be used correctly.

Bottom line: I think the comparison regarding ease of use is a
bit speculative at this point, but I think there is sufficient
reason for thinking that AppArmor might be a useful tool in some
deployment environments.

>I'd also argue that the typical interface presented to admins (which
>doesn't involve writing new policies) is easier for SELinux than with
>AppArmor. Most admins do fine with relabeling, changing booleans, and
>running audit2allow, which is all that is needed to solve the majority
>of SELinux issues.

Heh.  I had to chuckle at that one: it is pretty far removed from
my own personal experience.
