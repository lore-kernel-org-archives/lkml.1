Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbXJBUd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbXJBUd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 16:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbXJBUdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 16:33:49 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:3798 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbXJBUds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 16:33:48 -0400
X-IronPort-AV: E=Sophos;i="4.21,221,1188802800"; 
   d="scan'208";a="403492269"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, tglx@linutronix.de,
       torvalds@linux-foundation.org, mingo@elte.hu, ak@suse.de,
       greg@kroah.com, rusty@rustcorp.com.au, sam@ravnborg.org, hpa@zytor.com,
       peterz@infradead.org, venkatesh.pallipadi@intel.com, travis@sgi.com,
       avi@qumranet.com, jason.wessel@windriver.com, jeremy@goop.org,
       glommer@gmail.com, chrisw@sous-sol.org, clameter@sgi.com,
       ebiederm@xmission.com, anil.s.keshavamurthy@intel.com, zach@vmware.com,
       linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
X-Message-Flag: Warning: May contain useful information
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
	<alpine.LRH.0.999.0710021019310.23586@www.tglx.de>
	<200710022212.15219.rjw@sisk.pl>
	<20071002131131.6066eabe.akpm@linux-foundation.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 02 Oct 2007 13:32:36 -0700
In-Reply-To: <20071002131131.6066eabe.akpm@linux-foundation.org> (Andrew Morton's message of "Tue, 2 Oct 2007 13:11:31 -0700")
Message-ID: <adaejgdgsuz.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Oct 2007 20:32:37.0071 (UTC) FILETIME=[5EB8F5F0:01C80533]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > The one problem with this is that I will have trouble repulling and remerging
 > the 81 subsystem tree which are part of -mm until their owners have fixed
 > everything up - I'll either need to temporarily drop them or will need to
 > fix them up with Thomas's script each time I fetch them.

FWIW, I just pulled Thomas's x86 branch into my for-2.6.24 branch and
test-booted that on one of my systems with no obvious problems.  (Hey,
it compiled, ship it...)

 - R.
