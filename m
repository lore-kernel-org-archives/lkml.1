Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbXDEQcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbXDEQcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 12:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbXDEQcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 12:32:00 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:2663 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbXDEQb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 12:31:59 -0400
To: Tony Lindgren <tony@atomide.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/90] Post 2.6.21 OMAP update
X-Message-Flag: Warning: May contain useful information
References: <11757088774110-git-send-email-tony@atomide.com>
	<20070404182728.GK29129@atomide.com>
	<20070404113925.da221efc.randy.dunlap@oracle.com>
	<20070404184455.GL29129@atomide.com>
	<20070404224448.0ff60ed2@the-village.bc.nu>
	<20070405132144.GC24297@atomide.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 05 Apr 2007 09:31:57 -0700
In-Reply-To: <20070405132144.GC24297@atomide.com> (Tony Lindgren's message of "Thu, 5 Apr 2007 09:21:48 -0400")
Message-ID: <adar6qybx4y.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Apr 2007 16:31:57.0902 (UTC) FILETIME=[EDF39EE0:01C7779F]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > It would be enormously helpful if instead we got say 15 small patch sets
 > > which are independant so that a query or NAK means 14 sets get applied
 > > this time around not zero.
 > 
 > I was thinking about merging the patches together more, but the end result
 > would not be very readable, and we would lose the original author info.
 > 
 > Also trying to do this 15 small patches at time would make it hard
 > to have it all integrated within the two week merge window.

I think you misunderstood the suggestion.  The idea is that you leave
the patches basically as-is (modulo any small tweaks required by
reordering), but rather than one 90-patch series, you divide the
patches up into independent subsets.  Maybe something like

 - basic OMAP fixes for bugs in core support
 - Palm platform stuff
 - ...other platform stuff
 - new features

etc.  then it's easier for people to review the stuff they're
interested in, and it's easier for at least some of the subsets to get
applied (which reduces your backlog).

 - R.
