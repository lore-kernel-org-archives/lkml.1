Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYEZKZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYEZKZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 06:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYEZKZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 06:25:26 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:45735 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYEZKZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 06:25:25 -0400
Date: Mon, 26 May 2008 11:24:02 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "Theodore Ts'o" <tytso@mit.edu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #10732] REGRESSION: 2.6.26-rc2-git4: X server failed start
 on X61s laptop
In-Reply-To: <TW_YzGo9TFP.A.VVD.WeIOIB@albercik>
Message-ID: <Pine.LNX.4.64.0805261115470.3720@blonde.site>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik> <TW_YzGo9TFP.A.VVD.WeIOIB@albercik>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2008, Rafael J. Wysocki wrote:
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10732
> Subject		: REGRESSION: 2.6.26-rc2-git4: X server failed start on X61s laptop
> Submitter	: Theodore Ts'o <tytso@mit.edu>
> Date		: 2008-05-17 7:32 (8 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=121100994722524&amp;w=4

I believe this was fixed by Jeremy's PTE_MASK fixes in 2.6.26-rc3-git2,
but can only say that they fixed my own X with PAE since PAT mods problem.

Ted, when you have a chance, please try a recent kernel and let us
know if this regression can now be removed from the list - thanks.

Hugh
