Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbXD2JgH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbXD2JgH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 05:36:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbXD2JgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 05:36:07 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60211 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbXD2JgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 05:36:05 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <463466C3.3090604@s5r6.in-berlin.de>
Date: Sun, 29 Apr 2007 11:34:59 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: David Lang <david.lang@digitalinsight.com>
CC: David Miller <davem@davemloft.net>, mrechberger@gmail.com,
       torvalds@linux-foundation.org, bunk@stusta.de, diegocg@gmail.com,
       cebbert@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.21
References: <20070428195320.GZ3468@stusta.de><alpine.LFD.0.98.0704281529080. 9964@woody.linux-foundation.org><d9def9db0704281558r57460a6ft76bbddcc480058 eb@mail.gmail.com> <20070428.204048.125894473.davem@davemloft.net> <Pine.LNX.4.63.0704282339220.11975@qynat.qvtvafvgr.pbz>
In-Reply-To: <Pine.LNX.4.63.0704282339220.11975@qynat.qvtvafvgr.pbz>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Lang wrote:
> I'll say that as a user I hate having to deal with bugzilla.
> 
> there's nothing more frustrating then spending a good chunk of time
> trying to find a similar bug, then jumping through all the bugzilla
> hoops to file a report to eventually (days/weeks later) get a message
> 'closed becouse it's a duplicate report), then have to go and track down
> what it's a duplicate of, read through that bug report, only to find
> that it's not solved there either, and to top it off, the people working
> on that bug won't see my report or that I'm available to troubleshoot it.

Ideally, joining duplicate reports should be a low-cost, lossless operation.

That said, when bug B is marked as duplicate of bug A, people at bug A
at least get a link to bug B, aren't they?  If they are too lazy to read
the report B, they obviously are not very interested in A either.  Tough
luck.  Vice versa, people at bug B get notified that the matter is now
continued at bug A and can add their Cc there.  Of course that addition
is one of the very few things that could probably be automated.

Joining duplicate reports at a mailinglist involves responding to
multiple threads and send links into web archives of the list, which
happens to be redundant to and disparate from your local e-mail storage.
 I can't see how this aspect of bug-handling works easier on mailinglists.

> from a user poit of view, e-mailing the kernel list (retrying a few days
> later of there is no response) tends to work _much_ better.

What I from a maintainer's POV agree with is that a report to the
appropriate mailinglist is often easier to triage than a report at
bugzilla, because the reporter often needs initial help to properly
define the problem.  Bugzilla becomes useful after a report reached a
minimum level of quality (after minimum initial triage) and if the bug
can be clearly associated with a maintained subsystem of the kernel (as
e.g. Linus already pointed out in this thread).
-- 
Stefan Richter
-=====-=-=== -=-- ===-=
http://arcgraph.de/sr/
