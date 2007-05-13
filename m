Return-Path: <linux-kernel-owner+w=401wt.eu-S1759943AbXEMWHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943AbXEMWHE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 18:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756521AbXEMWGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 18:06:55 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:53164 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbXEMWGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 18:06:54 -0400
Date: Sun, 13 May 2007 15:12:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Markus =?ISO-8859-1?Q?Ko=DFmann?= <mkossmann_ml1@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: parallel port problems with 2.6.21_rc5 and
 2.6.21_rc6_git3-20070410174235
Message-Id: <20070513151201.f2b38720.randy.dunlap@oracle.com>
In-Reply-To: <200705051658.22817.mkossmann_ml1@gmx.de>
References: <200704112040.23505.mkossmann_ml1@gmx.de>
	<20070503132513.e3db44e9.randy.dunlap@oracle.com>
	<200705051658.22817.mkossmann_ml1@gmx.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2007 16:58:22 +0200 Markus Koßmann wrote:

> Am Donnerstag, 3. Mai 2007 schrieb Randy Dunlap:
> > On Wed, 11 Apr 2007 20:40:23 +0200 Markus Koßmann wrote:
> > > When using either the unpatched  2.6.21_rc5   or SUSEs patched
> > > 2.6.21_rc6_git3-20070410174235 on a SUSE-10.2 x86_64 system the parallel
> > > port doesn't work right. If I "cat some_asciifile >/dev/lp0"  the output
> > > on my Epson Stylus Color 880 is unreadable.  "cat /dev/zero >/dev/lp0" 
> > > creates random characters on the paper. Printing using cups also doesn't
> > > work any more.
> > > Switching back to SUSEs  2.6.18.8-0.1 kernel fixes the problem.
> > > Any Ideas, what might be broken here ?
> >
> > Nope, but I have the same problem.
> > I'll dig into it some day, but it's not very high priority for me.
> >
> > I haven't tested it lately.  Do you still see this problem?
> >
> Yes, it still exists with SUSEs  2.6.21-20070502152652 kernel. Didn't check 
> with vanilla 2.6.21 yet. 

Hi Markus,

I just retested this on 2.6.21-git12 and didn't have a problem
with printing.  Can you test on 2.6.22-rc1?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
