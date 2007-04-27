Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbXD0Poc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbXD0Poc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbXD0Poc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:44:32 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33733 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755953AbXD0Po3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:44:29 -0400
Message-ID: <46321A5A.2030602@austin.ibm.com>
Date: Fri, 27 Apr 2007 10:44:26 -0500
From: jschopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org
Subject: Re: patch style checks
References: <20070423141123.GA21174@skybase>	<20070425143011.57247c1d.akpm@linux-foundation.org>	<20070425172447.1576c399.akpm@linux-foundation.org>	<200704260232.06909.arnd@arndb.de> <20070425180611.25c563d4.akpm@linux-foundation.org> <463206E3.9040309@shadowen.org>
In-Reply-To: <463206E3.9040309@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Methinks it should do `exit 1' if anything was detected.
> 
> [Joel in case you'd not spotted this discussion, your
> patchstylecheckemail script was found ...  Also this has produced a
> little patch series improving the tool.  Where would you like that sent?]

Heh.  It's pretty crude but I've found it useful even as crude as it is.  I have been 
doing library work instead of kernel work for a little more than a year so I haven't been 
improving it.  That said, I'd be happy to see patches as I expect I'll do kernel work 
again in the future.  I had made a project page for it here: 
http://code.google.com/p/patchstylecheck/

I'll maintain it if people want to send me patches.  I also added Andy to the svn 
commiters list awhile back, so you could bug him as well.

> 2.6.21-rc7-mm2 appears to contian some 4313 commits in total!!!  Of
> these some 886 failed the style check; over 20%.  Obviously some of
> these will be false positives, or actually better as they are than made
> compliant.  I did have a quick look over a sample of the errors and bad
> use of space at the start and end of line, plus overlength lines, and
> the lack of spaces round operators seem to be the predominant errors
> therein.

Whitespace damage is the predominant one I've seen as well.  When I was developing it I 
fed it a number of lkml patches at random and fixed all the false positives I encountered.
