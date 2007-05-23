Return-Path: <linux-kernel-owner+w=401wt.eu-S1757805AbXEWCjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805AbXEWCjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 22:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbXEWCjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 22:39:44 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:38281 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbXEWCjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 22:39:42 -0400
X-IronPort-AV: i="4.14,567,1170662400"; 
   d="scan'208"; a="153052449:sNHT1009883826"
To: Rob Landley <rob@landley.net>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: Cleaning up the Documentation directory.
X-Message-Flag: Warning: May contain useful information
References: <200705222225.39949.rob@landley.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 22 May 2007 19:38:47 -0700
In-Reply-To: <200705222225.39949.rob@landley.net> (Rob Landley's message of "Tue, 22 May 2007 22:25:39 -0400")
Message-ID: <adaps4sb6x4.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 May 2007 02:38:48.0200 (UTC) FILETIME=[7D987080:01C79CE3]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 >   cd Documentation
 >   mkdir -p arch/amiga
 >   mv zorro.txt arch/amiga
 >   mv arm cris blackfin parisc powerpc s390 x86_64 uml arch
 >   mv sx.txt stallion.txt specialix.txt rocket.txt riscom8.txt \
 >      computone.txt hayes-esp.txt moxa-smartio serial

 > I could send a patch to do this, but moving files via patch is icky.  Would it 
 > be better to start a git tree and ask people to pull from it, or to send in 
 > script snippets like the above?

Actually a git patch would express that very nicely -- just pass -M to
git-format-patch and it should do the right thing.

 - R.
