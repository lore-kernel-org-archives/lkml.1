Return-Path: <linux-kernel-owner+w=401wt.eu-S1751800AbZL2AnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbZL2AnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 19:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751653AbZL2AnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 19:43:01 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:51659 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbZL2AnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 19:43:00 -0500
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: RFC: disablenetwork facility. (v4)
Date: Tue, 29 Dec 2009 00:42:55 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hhbjaf$vjr$1@taverner.cs.berkeley.edu>
References: <hhback$sor$1@taverner.cs.berkeley.edu> <18731.1262044487@localhost>
Reply-To: daw-news@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1262047375 32379 128.32.153.193 (29 Dec 2009 00:42:55 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Tue, 29 Dec 2009 00:42:55 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Granted - but "is it embedded in code anywhere" is different from "does
> anybody use such a policy".

OK, that's fine.  But "is it embedded in code anywhere" is the
question that matters to this thread.  And not just in code "anywhere",
but in code in a setuid-root executable that would become vulnerable if
Michael's scheme is introduced (yet is not already vulnerable today).

To refresh: the original context was that Pavel objected to Michael's
disablenetwork scheme on the basis that it could introduce new security
vulnerabilities, if some setuid-root program somewhere is written to
enforce a specific policy.  So, to my way of thinking, the only reason to
spend any energy on this question at all is to determine whether Pavel's
objection is persuasive.  I'm arguing the objection is not persuasive.
And I'm suggesting that we focus on the question that matters, rather
than getting distracted by imprecise phrasing Michael may have used when
he asked the question.

(Sorry for the misattribution, by the way; I attempted to clean up
the quoting and made it worse!  Sorry.)

> Out of curiosity, any of the other security types here ever included "getting
> the damned semi-clued auditor who insists on cargo-cult checklists out of your
> office" as part of your threat model?  Only a half-smiley on this one...

Sure. :-)  One big catch-phrase that covers a lot of this ground is
'compliance'.  Recently there seems to be considerable discussion
among security professionals about the tension between 'compliance' and
'security', and whether increased attention to 'compliance' benefits
'security' or is in the end a distraction.
