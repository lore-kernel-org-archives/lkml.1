Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbXD0OWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbXD0OWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbXD0OWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:22:38 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3127 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921AbXD0OWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:22:13 -0400
Message-ID: <463206E3.9040309@shadowen.org>
Date: Fri, 27 Apr 2007 15:21:23 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Joel Schopp <jschopp@austin.ibm.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org
Subject: patch style checks
References: <20070423141123.GA21174@skybase>	<20070425143011.57247c1d.akpm@linux-foundation.org>	<20070425172447.1576c399.akpm@linux-foundation.org>	<200704260232.06909.arnd@arndb.de> <20070425180611.25c563d4.akpm@linux-foundation.org>
In-Reply-To: <20070425180611.25c563d4.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 26 Apr 2007 02:32:06 +0200 Arnd Bergmann <arnd@arndb.de> wrote:
> 
>> On Thursday 26 April 2007, Andrew Morton wrote:
>>> It would be neat if someone could create and maintain a new
>>> scripts/spot-common-mistakes.  Feed it a unified diff and it would complain
>>> about newly-added code (and only newly-added code) which has busted
>>> whitespace, adds new semaphores, adds new kernel_thread calls, etc, etc.
>> http://patchstylecheck.googlecode.com/svn/trunk/patchstylecheckemail.pl
>> Might serve as a starting point for this. It doesn't have any semantic
>> checks right now, but I guess they can be added.
>>
> 
> 	print "Your patch is now worthy to be reviewed by a real person\n";
> 
> heh.  Yes, that looks like an ideal starting point.
> 
> Methinks it should do `exit 1' if anything was detected.

[Joel in case you'd not spotted this discussion, your
patchstylecheckemail script was found ...  Also this has produced a
little patch series improving the tool.  Where would you like that sent?]

As an experiment I took the -mm git repo and applied a modified versions
of the patchstylecheckemail.pl to all the of the commits reported
between 2.6.21-rc7 and 2.6.21-rc7-mm2.  The git version of -mm links
directly back to the real incoming git trees and so we get the
individual commits there also.

2.6.21-rc7-mm2 appears to contian some 4313 commits in total!!!  Of
these some 886 failed the style check; over 20%.  Obviously some of
these will be false positives, or actually better as they are than made
compliant.  I did have a quick look over a sample of the errors and bad
use of space at the start and end of line, plus overlength lines, and
the lack of spaces round operators seem to be the predominant errors
therein.

As these are coming from the git commits, we could consider sending an
email to those authors.  However, as we are only considering patches in
isolation we cannot see if they got fixed later for instance.

In an ideal world we would do the same sort of analysis on the files as
the appear in the HEAD of the tree.  Any lines in error then would be
attributed to an author and that author told to fix their mess.  Hmmm,
not so hard me thinks.

-apw
