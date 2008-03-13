Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYCMHDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYCMHDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 03:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbYCMHDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 03:03:10 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45537 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751572AbYCMHDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 03:03:09 -0400
Date: Thu, 13 Mar 2008 02:03:00 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: menage@google.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: boot cgroup questions
Message-Id: <20080313020300.92244956.pj@sgi.com>
In-Reply-To: <47D87BE5.4010702@qualcomm.com>
References: <47D73086.2030008@qualcomm.com>
	<6599ad830803111827n1cb8e2c7i47c2ef3f3bb58995@mail.gmail.com>
	<47D7411E.1000009@qualcomm.com>
	<6599ad830803111936jd940deam8584bc971c3b6f41@mail.gmail.com>
	<47D74595.4080100@qualcomm.com>
	<6599ad830803112009y18d9e43ft8e3fc4a551d891da@mail.gmail.com>
	<20080311235939.1ebee8e3.pj@sgi.com>
	<47D81FE1.6030205@qualcomm.com>
	<20080312135746.89456f2a.pj@sgi.com>
	<47D82AD2.1070108@qualcomm.com>
	<20080312143253.3dd72c7f.pj@sgi.com>
	<47D83858.4030806@qualcomm.com>
	<20080312153712.bc5df7a1.pj@sgi.com>
	<47D8593A.6040503@qualcomm.com>
	<20080312183059.6716d630.pj@sgi.com>
	<47D87BE5.4010702@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max K wrote:
> cleaner imo than dealing with complex irq grouping schemes.

What's this "complex irq grouping scheme" that you're referring to?

If it's what I posted last week, with named sets of irqs, and each
cpuset naming which set it belonged to, that seems to me to actually
fit the usage pattern rather well.

The jobs running in particular cpusets need only know the 'name' of
the set of irqs it makes sense to send to its CPUs (the realtime
irqs, a particular piece of hardwares irqs, the ordinary system
irqs, the absolute minimum set of irqs, ...) and the system admin
gets to specify, one time, which irq numbers are in which named
set, or to change, later on, which set a particular irq is in, all
without having to have detailed knowledge of the jobs that want
particular irq sets directed to their CPUs.

We tend to label whatever makes sense to us as "simple", and whatever
doesn't seem necessary in our experience, or doesn't make sense, as
"complex".

Such labels are losing their meaning these days, other than to help
others figure out what we favor, or disfavor.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
