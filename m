Return-Path: <linux-kernel-owner+w=401wt.eu-S1754402AbYCLTdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbYCLTdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 15:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYCLTc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 15:32:57 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53950 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751400AbYCLTc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 15:32:56 -0400
Date: Wed, 12 Mar 2008 14:32:53 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: menage@google.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: boot cgroup questions
Message-Id: <20080312143253.3dd72c7f.pj@sgi.com>
In-Reply-To: <47D82AD2.1070108@qualcomm.com>
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
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> I was talking about running on the _cpus_ that belong to the "sets A and B but 
> not C" and not that a task must belong to more than one cpuset.

This doesn't make sense to me.

If a task is to run on the CPUs in both sets A and B, then it has to be
in both those cpusets, which isn't allowed, or in some super set of both
A and B (that is, in this example, in the top cpuset), which doesn't
restrict the task to just A or B or their union.

I have no idea what distinction you are seeing between what _cpus_ a task
can run on, and what cpuset it belongs to.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
