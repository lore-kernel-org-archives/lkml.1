Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbYG0Dus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbYG0Dus (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 23:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbYG0Duk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 23:50:40 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:23397 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbYG0Duj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 23:50:39 -0400
X-IronPort-AV: E=Sophos;i="4.31,257,1215388800"; 
   d="scan'208";a="58095695"
From: Roland Dreier <rdreier@cisco.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Kara <jack@ucw.cz>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: 2.6.26-mmotm-0724 - linux-next.git loses /proc/sys/fs/quota, breaks disk quotas
References: <14615.1217125366@turing-police.cc.vt.edu>
	<20080726202525.3ac3052f.akpm@linux-foundation.org>
	<21657.1217130229@turing-police.cc.vt.edu>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 26 Jul 2008 20:50:37 -0700
In-Reply-To: <21657.1217130229@turing-police.cc.vt.edu> (Valdis Kletnieks's
	message of "Sat, 26 Jul 2008 23:43:49 -0400")
Message-ID: <adatzec56k2.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 Jul 2008 03:50:37.0837 (UTC) FILETIME=[EE611BD0:01C8EF9B]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I've bisected through Linus' tree more than once - ISTR that there was
 > some special funkiness in dealing with trying to bisect through linux-next
 > because the tree gets redone every night.

 > If it *was* as easy as Linus's tree to bisect, I'd go ahead and do it.

For a single day's linux-next tree, it should be just like Linus's
tree... just clone

    git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

and bisect as usual.

The funkiness is that if you say, "linux-next from July 24 worked,
linux-next from July 25 didn't," then it's pretty much hopeless, exactly
because those two trees were built independently.

 - R.
