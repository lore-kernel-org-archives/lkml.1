Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbXKEVgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbXKEVgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 16:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbXKEVgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 16:36:46 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:2416 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXKEVgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 16:36:45 -0500
X-IronPort-AV: E=Sophos;i="4.21,374,1188802800"; 
   d="scan'208";a="184981799"
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] replace "make ARCH=i386/x86_64 with make ARCH=x86"
X-Message-Flag: Warning: May contain useful information
References: <20071103234826.GA26654@uranus.ravnborg.org>
	<20071105104129.GB3662@infradead.org>
	<20071105171740.GA29481@uranus.ravnborg.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 05 Nov 2007 13:36:42 -0800
In-Reply-To: <20071105171740.GA29481@uranus.ravnborg.org> (Sam Ravnborg's message of "Mon, 5 Nov 2007 18:17:40 +0100")
Message-ID: <adafxzkbcid.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Nov 2007 21:36:43.0188 (UTC) FILETIME=[F53B5740:01C81FF3]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Like this:
 > $ make ARCH=foo
 > Makefile:201: *** "ERROR: ARCH (foo) does not exist".  Stop.

Seems sane, but maybe it would be worth putting in a special case
check for someone using i386 or x86_64 for ARCH, and tell them to
switch to x86?

 - R.
