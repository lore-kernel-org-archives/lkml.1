Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbZE1WVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbZE1WVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbZE1WVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:21:17 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:63914 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZE1WVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:21:16 -0400
X-IronPort-AV: E=Sophos;i="4.41,267,1241395200"; 
   d="scan'208";a="191642953"
From: Roland Dreier <rdreier@cisco.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Ky Srinivasan <ksrinivasan@novell.com>,
       Beulich <jbeulich@novell.com>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 17/17] xen: disable MSI
References: <1243409850-21577-1-git-send-email-jeremy@goop.org>
	<1243409850-21577-18-git-send-email-jeremy@goop.org>
	<alpine.LFD.2.01.0905270829530.3435@localhost.localdomain>
	<20090527211828.GA6166@elte.hu>
	<alpine.LFD.2.01.0905271436140.3435@localhost.localdomain>
	<adavdnm5hkx.fsf@cisco.com>
	<20090528072844.4c1db656@lxorguk.ukuu.org.uk>
	<20090527233807.e7e39e97.akpm@linux-foundation.org>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 28 May 2009 15:21:14 -0700
In-Reply-To: <20090527233807.e7e39e97.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 27 May 2009 23:38:07 -0700")
Message-ID: <adaab4w6f8l.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 May 2009 22:21:15.0119 (UTC) FILETIME=[9D4927F0:01C9DFE2]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Yup.  I presently use "Addresses: <url>" in the changelog.
 > 
 > y:/usr/src/git26> git-log | grep '^    Addresses.*bugzilla' | wc -l
 > 36
 > 
 > Formalising that a bit more would be good.
 > 
 > Not all patches literally "close" a bugzilla report though.  Sometimes
 > there's related info in bugzilla but the bug remains.  But
 > "closes-bug:" is close enough.

Yes, I deliberately didn't suggest "Fixes-bug:" but I like your
"Addresses:" language even better.  I'll start using that for any
commits from now on.

 - R.
