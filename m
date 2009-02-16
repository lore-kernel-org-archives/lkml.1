Return-Path: <linux-kernel-owner+w=401wt.eu-S1753220AbZBPSEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220AbZBPSEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 13:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbZBPSE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 13:04:27 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57883 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbZBPSE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 13:04:26 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4999AA93.5030009@s5r6.in-berlin.de>
Date: Mon, 16 Feb 2009 19:04:03 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>, Manish Katiyar <mkatiyar@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Remove errors caught by checkpatch.pl in	kernel/kallsyms.c
References: <ea11fea30902151034s5444efabw455c1dac1b875086@mail.gmail.com> <20090215184752.GA4970@uranus.ravnborg.org> <4999650C.6030700@s5r6.in-berlin.de> <20090216132822.GC17996@elte.hu> <4999717F.7090205@s5r6.in-berlin.de> <20090216141917.GA8981@elte.hu> <499984C1.6020004@s5r6.in-berlin.de> <20090216155023.GA4422@elte.hu> <4999908D.4050403@s5r6.in-berlin.de> <20090216171233.GB25907@elte.hu>
In-Reply-To: <20090216171233.GB25907@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> That position of not adding tool information to the commit log is not 
> just not tenable but also incredibly silly.

It's not a hard requirement; it's a rule of thumb to detect changelogs
which lack important information.

I made it sound like a hard requirement for simplicity's sake. :-)

(The rule works thusly:  If the author put irrelevant information into
the log, then this is a sign that insufficient care was taken and hence
there is a danger that necessary information was forgotten.)

> Those tools are useful, they result in fixes, so why should the patch 
> author pretend and hide the method of finding problems from the Git 
> history?

Because the result is what counts:  What is the change doing?  Why
change the source in this way?

The changelogs don't teach programming or discuss our development
methods.  They are not a channel for feedback from tools users to tools
developers.

I stress again that putting irrelevant information into the log is
almost as bad as forgetting relevant information.  The S/N ratio is
lowered by the latter /and/ by the former.

> We often write "found via review" or "found via testing". It's 
> useful and it gives people an idea of how certain types of fixes were 
> found.

We write it
  - to acknowledge the work which was spent by people,
  - to describe under which circumstances an issue was reproducible.

"I used script XYZ to find whitespace style deviations" is fundamentally
different from "I used this and that benchmark setup to produce the
following results" --- because there are several alternative and
*obvious* ways to find style deviations, while there may be only
non-trivial and highly specific ways to reproduce a bug or performance
result.
-- 
Stefan Richter
-=====-==--= --=- =----
http://arcgraph.de/sr/
