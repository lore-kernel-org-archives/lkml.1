Return-Path: <linux-kernel-owner+w=401wt.eu-S932336AbZE0WUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbZE0WUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 18:20:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757314AbZE0WUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 18:20:46 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:50583 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZE0WUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 18:20:45 -0400
X-IronPort-AV: E=Sophos;i="4.41,261,1241395200"; 
   d="scan'208";a="191036504"
From: Roland Dreier <rdreier@cisco.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 17/17] xen: disable MSI
References: <1243409850-21577-1-git-send-email-jeremy@goop.org>
	<1243409850-21577-18-git-send-email-jeremy@goop.org>
	<alpine.LFD.2.01.0905270829530.3435@localhost.localdomain>
	<20090527211828.GA6166@elte.hu>
	<alpine.LFD.2.01.0905271436140.3435@localhost.localdomain>
	<adavdnm5hkx.fsf@cisco.com>
	<alpine.LFD.2.01.0905271511440.3435@localhost.localdomain>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 27 May 2009 15:20:46 -0700
In-Reply-To: <alpine.LFD.2.01.0905271511440.3435@localhost.localdomain> (Linus
	Torvalds's message of "Wed, 27 May 2009 15:13:10 -0700 (PDT)")
Message-ID: <adamy8y5gsh.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 27 May 2009 22:20:46.0960 (UTC) FILETIME=[6216AF00:01C9DF19]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I agree that that would work, but that way also lies endless other tags. 
 > People seem to always want to have some magic tag to grep for, if we can 
 > make 'impact:' be it rather than have potentially lots of random ones, 
 > maybe impact: is simply better?

Dunno... maybe just "Tag:"?  ;)

Maybe just "git log|grep 'bug url'" is good enough without having to
make any special format?

 - R.
