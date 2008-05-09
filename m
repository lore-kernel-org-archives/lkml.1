Return-Path: <linux-kernel-owner+w=401wt.eu-S1761132AbYEILRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761132AbYEILRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbYEILRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:17:32 -0400
Received: from relay2.sgi.com ([192.48.171.30]:40125 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753998AbYEILRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:17:30 -0400
Date: Fri, 9 May 2008 06:17:27 -0500
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: maxk@qualcomm.com, menage@google.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: IRQ affinities (was: boot cgroup questions)
Message-Id: <20080509061727.5057de1f.pj@sgi.com>
In-Reply-To: <1210329926.13978.224.camel@twins>
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
	<20080313020300.92244956.pj@sgi.com>
	<47FE5655.10900@qualcomm.com>
	<20080414133902.7878cfce.pj@sgi.com>
	<1210329926.13978.224.camel@twins>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter wrote:
> That's a new feature; and its quite common that new features require
> code changes.

It's common for new features to require code changes to take advantage
of the new features.

It's less desirable that taking advantage of such new features breaks
existing, basically unrelated, code.

My gut sense is that, in a misguided effort to find a "simple" answer
to irq distribution, we (well, y'all) are trying to attach this
feature to cpusets or cgroups.

Let me ask a different question:

  What solutions would you (Max, Peter, Ingo, lurkers, ...) be
  suggesting for this 'IRQ affinity' problem if cpusets and
  cgroups didn't exist in any form whatsoever?

The answer to that question might help me contribute to this discussion
in another way ... it might help me understand better what we're really
trying to do here.  You guys were proposing mechanisms that don't fit
my architecture sense of cpusets, but I was having problems figuring out
what are the essential underlying requirements, independent of choice
of mechanism.

Perhaps by describing one or two possible alternative, cpuset-free,
mechanisms that come more or less close to meeting our needs, I will
glean a better understanding of these elusive requirements, and can
better contribute to the discussion of design trade offs facing us.

So could you describe some possible cpuset-free solutions?  If they are
flawed in some critical way, that's ok, just point out said flaw(s).
Either way, this could help illuminate what's needed here.

It might be, once I better understand the requirements, possible
solutions and their tradeoffs, that I come to agree that cpusets or
cgroups present the best mechanism, given the tradeoffs and what's
needed.  Or it might be we find a better way to meet our needs.

Actually, if for no other reason than to bring any lurkers up to speed,
if you (Max or Peter, likely) wanted to describe, from the beginning,
what this discussion is about, that would be good too.  I doubt anyone
outside of three or four of us even recalls that long discussion of
February and March, 2008.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
