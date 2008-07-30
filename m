Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbYG3Vbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbYG3Vbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbYG3VbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:31:07 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:15208 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbYG3VbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:31:05 -0400
X-IronPort-AV: E=Sophos;i="4.31,281,1215388800"; 
   d="scan'208";a="91355496"
From: Roland Dreier <rdreier@cisco.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Amanda McPherson <amanda@amcpherson.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC] A development process document
References: <20080729143015.0f79cf37@bike.lwn.net>
	<Pine.LNX.4.64.0807301307060.26427@twin.jikos.cz>
	<20080730145600.7b61a43a@bike.lwn.net>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 30 Jul 2008 14:30:58 -0700
In-Reply-To: <20080730145600.7b61a43a@bike.lwn.net> (Jonathan Corbet's message
	of "Wed, 30 Jul 2008 14:56:00 -0600")
Message-ID: <ada3alrys8d.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Jul 2008 21:30:58.0492 (UTC) FILETIME=[8E7BE7C0:01C8F28B]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > On the other hand, the drivers for completely new hardware (that has
 > > been totally unsupported by the kernel previously, so there is no
 > > possibility for introducing regressions) are still allowed even after
 > > -rc1, right? 
 > 
 > Clearly it's been known to happen (can you say GRU?).  But I don't know
 > that has ever really been adopted as an "official" policy.  My
 > preference would be to lay down the merge window rules as a fairly firm
 > thing rather than suggest to people that there might be ways to slip
 > around them sometimes.  But, certainly, I'm not tied to that if we want
 > to send a different message.

I think Linus has said pretty explicitly that he is willing to merge new
low-level hardware drivers at pretty much any stage, as long as they are
obviously self-contained and can't break anything.  As an example of
this, the UVC webcam driver was one of the very last things merged just
before the final 2.6.26 release, very late in the release cycle.

Obviously there is some judgement involved in what qualifies as new
hardware drivers, but Linus also often comes out in favor of thinking
about things rather than trying to apply mechanical rules anyway.
