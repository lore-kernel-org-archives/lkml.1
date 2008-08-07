Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbYHGMgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbYHGMgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbYHGMfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:35:39 -0400
Received: from smtp2.Stanford.EDU ([171.67.20.25]:45383 "EHLO
	smtp2.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbYHGMfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:35:36 -0400
X-Greylist: delayed 387 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Aug 2008 08:35:36 EDT
Message-ID: <20080807052905.f3ijvmuxsgkowwww@webmail.stanford.edu>
Date: Thu, 07 Aug 2008 05:29:05 -0700
From: Philip Guo <pg@cs.stanford.edu>
To: linux-kernel@vger.kernel.org
Subject: research questionnaire about kernel development
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.5)
Authenticated-User: pgbovine
X-Originating-IP: 128.30.84.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SUMMARY:

This is a request for comments on 14 assertions about kernel
development to give a grad student qualitative insight into the
quantitative data he has gathered on kernel development.  Make
comments by email replying directly to me.

---
INTRODUCTION:

I am a CS graduate student at Stanford University working in the
research group that developed the Stanford Checker, a static code
analysis tool that has found numerous kernel bugs and posted reports
to LKML in the past few years.

In the past year, I've been doing an empirical study of how Linux
kernel development occurs and how developers respond to bug reports.
I'm planning to submit my findings for review as a research paper, but
before I do so, I would like to receive some feedback from kernel
developers.  I don't feel qualified to craft qualitative explanations
out of my purely quantitative results (e.g., 'these X numbers show
that developers are behaving in Y way'); to do so would be to unjustly
speculate, since I have never been active in kernel development.

I would really appreciate it if you could assist my research by
filling out this questionnaire (as much of it as you have time for)
and sending it as an email reply to me.  For brevity, I will simply
make assertions (derived from my data analysis) and then ask for your
insights about their veracity.  Please let me know if you have any
questions or want to view the raw data before making your responses.

Thanks in advance,
Philip Guo
pg@cs.stanford.edu

---
ASSERTIONS:

For each, please state whether you agree, and if so, why you think it
is true based upon your own experiences, intuitions, and anecdotes.
Likewise, if you disagree, state why you think it sounds erroneous.


   Assertion 1: Files are less actively modified as they age (i.e.,
   older files are subject to fewer and smaller-sized patches than
   younger files)


   Assertion 2: Files with lots of patches (dozens to hundreds) remain
   actively-patched throughout their lifetimes, but files with few
   patches get most of their patches at the beginning of their lives
   and then aren't patched much afterwards.


   Assertion 3: Patches cluster in time --- if a file is patched during
   a particular week, then it is more likely than average to be patched
   in the near future


   Assertion 4: Files with more non-bugfix patches usually have more
   bugs reported (and fixed) than files with fewer patches.



Since 2006, the Coverity Scan project (scan.coverity.com) has found
and reported a few thousand potential bugs in Linux using an automated
static analysis tool.  Developers can log into the website and triage
the bug reports, marking each one as either a true bug or a false
positive and whether/when it is fixed.  In my dataset, 60% of the
~2,000 reports are triaged (and the rest are ignored).


   Assertion 5: Files/directories where automated code analysis tools
   (e.g., Sparse, Coverity Scan) flag more potential bugs actually
   contain more user-reported bugs.


   Assertion 6: Coverity Scan reports in younger files are more likely
   to be triaged and fixed.


   Assertion 7: Coverity Scan reports in smaller files (i.e., those
   with fewer num. lines) are more likely to be triaged and fixed.


   Assertion 8: The longer it takes for developers to triage a Coverity
   Scan bug report, the lower chance that it has of being marked as a
   true bug and eventually fixed.


   Assertion 9: If developers triage bug reports in a certain file and
   mark them as true bugs, then they are more likely to triage future
   reports in the same file.


   Assertion 10: If developers triage bug reports in a certain file and
   mark them as false positives, then they are more likely to IGNORE
   future reports for that same file.



A 'prolific kernel developer' is someone who has written a substantial
number of kernel patches (in the dozens or hundreds).  A 'regular
kernel developer' is someone who has written around a dozen or fewer
kernel patches.  The top 1% most prolific kernel developers have
written ~50% of all patches since 2002, and the top 20% have written
93% of all patches.


   Assertion 11: As compared to prolific developers, regular kernel
   developers write more patches that add new files to the repository
   or insert new lines to existing files.


   Assertion 12: As compared to regular devs., prolific devs. write
   more patches that do code cleanup, refactoring, and predominantly
   delete lines of code.


   Assertion 13: Files with larger percentages of their patches written
   by prolific developers have fewer Coverity Scan-reported bugs and
   also fewer bugfix patches committed.



A '.com developer' is someone with a .com email address (excluding
free email services like gmail.com or hotmail.com).  .com developers
have written 66% of all patches since 2002.  Many prolific developers
are also .com devs.: 66% of the top 1% most prolific devs.  are also
.com devs.


   Assertion 14: Files with larger percentages of their patches written
   by .com developers have fewer Coverity Scan-reported bugs and also
   fewer bugfix patches committed.


