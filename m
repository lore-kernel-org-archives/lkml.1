Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbYJUOWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbYJUOWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 10:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYJUOWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 10:22:06 -0400
Received: from fortimail.matc.edu ([148.8.129.21]:37564 "EHLO matc.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751771AbYJUOWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 10:22:05 -0400
X-Greylist: delayed 1599 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Oct 2008 10:22:05 EDT
Message-Id: <48FD98FA.8C56.0056.0@matc.edu>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 21 Oct 2008 08:55:16 -0500
From: "Jonathan Johnson" <johnsonn@matc.edu>
To: <linux-kernel@vger.kernel.org>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <tglx@linutronix.de>,
       <trimarchimichael@yahoo.it>
Subject: Re: commit f6121f4f8708195e88cbdf8dd8d171b226b3f858 upstream
References: <48FCA742.8C56.0056.0@matc.edu>
 <20081020204516.GA21825@suse.de> <1224575797.6629.9.camel@Palanthas>
In-Reply-To: <1224575797.6629.9.camel@Palanthas>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
X-FEAS-SYSTEM-WL: johnsonn@matc.edu, 148.8.29.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

  sched_rt.c: resch needed in rt_rq_enqueue() for the root rt_rq
    
    commit f6121f4f8708195e88cbdf8dd8d171b226b3f858 upstream

Many previous kernels up to and include 2.6.27.1 have had a "wa" time of 48-50% based on top or vmstat 1 100(last column heading, on the right).
After applying kernel 2.6.27.2 the read "wa" time has dropped for reads down to 0%-10%.  After reading the changelog
I used the same .config for this kernel as several previous ones.
I figured it must be this commit that made the different, since there are only about 12 commits and this seem most likely.

THANK YOU

However,  the "wa" times remain at 40%-50%(50% maybe 100% of one CPU core and its a dual) for writing and/or output.  I don't know if there is a corresponding queue for writing or output,
 but it also needs examining.  I don't know how it related to reading from the hard drive either, but it was a dramatic improvement.  Given that all on my hardware is almost "top-of-the-line", I
don't believe my hardware is at fault for the high "wa"(waiting for data).

My write speed especially to my RAID 6 seems to get worse and worse.  I have all the same and supported hard drives.  My original array had 6 mismatched drives at 20-24mb/s write speed.
I replaced them with 4 1TB drives and now write speed is under 100k/s especially when tranmitting data to this computer over the network.

I know some C++, but have never debug a program on this scale, and don't even know how to start.  Any advice would be appreciated.


Later,
Jonathan


