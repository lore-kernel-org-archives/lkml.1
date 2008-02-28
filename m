Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbYB1ANA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbYB1ANA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757838AbYB1AMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:12:51 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:60771 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974AbYB1AMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:12:50 -0500
To: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: hpwdt oops in clflush_cache_range
X-Message-Flag: Warning: May contain useful information
References: <adad4qiwcmz.fsf@cisco.com>
	<alpine.LFD.1.00.0802271913050.7583@apollo.tec.linutronix.de>
	<ada1w6y1bzk.fsf@cisco.com>
	<alpine.LFD.1.00.0802272011130.7583@apollo.tec.linutronix.de>
	<20080227203655.GA30054@elte.hu>
	<alpine.LFD.1.00.0802272140050.7583@apollo.tec.linutronix.de>
	<alpine.LFD.1.00.0802272155190.7583@apollo.tec.linutronix.de>
	<ada3areyu7x.fsf@cisco.com>
	<E14D1C2A44812C4F9C3ED321127EDF6505829D59DF@G3W0854.americas.hpqcorp.net>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 27 Feb 2008 16:12:46 -0800
In-Reply-To: <E14D1C2A44812C4F9C3ED321127EDF6505829D59DF@G3W0854.americas.hpqcorp.net> (Thomas Mingarelli's message of "Wed, 27 Feb 2008 23:44:57 +0000")
Message-ID: <adamypmx7k1.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Feb 2008 00:12:48.0793 (UTC) FILETIME=[A6A8C090:01C8799E]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Did I read correctly that this was on a Debian OS? Looks like I need to jump in and see what is different about Debian because I haven't seen such an issue on RedHat 5.
 > 
 > Yes, the driver was made specifically for G5 (and newer) systems. I will set a system up here and figure out what's wrong as soon as I am sure it is Debian.

I can't imagine that the fact that it's Debian has anything to do with
it -- this is purely in the kernel.

 - R.
