Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbXLOTpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbXLOTpO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 14:45:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbXLOTpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 14:45:01 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:38896 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbXLOTpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 14:45:00 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47642E98.6090405@s5r6.in-berlin.de>
Date: Sat, 15 Dec 2007 20:44:24 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.9) Gecko/20071122 SeaMonkey/1.1.6
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       protasnb@gmail.com
Subject: Re: Top kernel oopses/warnings this week
References: <4762CF8C.90808@linux.intel.com> <4763F771.10105@s5r6.in-berlin.de> <47641B0F.3040709@linux.intel.com>
In-Reply-To: <47641B0F.3040709@linux.intel.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Stefan Richter wrote:
>> Report counts may be too high due to duplicate recognition of the very
>> same report.
> 
> this is true however it's .. a hard issue. It's really hard to
> distinguish a duplicate report from two reports of the same bug.

Would be nice though to try to find duplicates like the example I gave.
(The actual report and a reply was listed.  The reply just had a full
quote of the oops, with "> " prepended and perhaps lines wrapped.)
Because if an oops is independently reported twice or more, this too
says something about the issue.  E.g. flaky RAM and such is pretty much
eliminated as a possible cause.

Anyway, someone who is actually interested in a particular oops and
looks at the posts in your links quickly notices eventual duplicates.
But it would be helpful to people who only have a quick glance at the
bar graphs if you add a note of caution that the figures are not
accurate and not representative, e.g. because of occasional duplicates.

For the same reason, please don't write headings like "Oops statistics
for kernel 2.6.23-release".  Unless you mean "statistics" in a narrower
sense like they do statistics in medicine and economics. ;-)
Simply write "Oops reports for kernel...".

>> Reports against 2.6.X-rcY-mmZ are listed in the same category as reports
>> against 2.6.X-rcY.  To distinguish -mm reports from vanilla reports, one
>> has to look into the details of each bug entry.¹
> 
> finding what exact kernel version an oops is from is... surprisingly hard.
> And to be honest, bugs against -mm are still very interesting, since
> they'll be the next mainline after all

Yes, they definitely are interesting.  And it's the same like with the
above issue:  People who are genuinely interested in an oops find the
necessary information at the details page.  Separating them from
mainline oopses would be a service though for people who want to
  - have a quick look at what's urgent and what's not so urgent,
  - draw conclusions about the state of the release candidates.
So this is not that important.
-- 
Stefan Richter
-=====-=-=== ==-- -====
http://arcgraph.de/sr/
