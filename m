Return-Path: <linux-kernel-owner+w=401wt.eu-S1761647AbYEIMD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761647AbYEIMD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbYEIMDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:03:18 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50141 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755103AbYEIMDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:03:17 -0400
Date: Fri, 9 May 2008 07:03:14 -0500
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: maxk@qualcomm.com, menage@google.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: IRQ affinities (was: boot cgroup questions)
Message-Id: <20080509070314.f86aece4.pj@sgi.com>
In-Reply-To: <1210333738.13978.246.camel@twins>
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
	<20080509061727.5057de1f.pj@sgi.com>
	<1210333738.13978.246.camel@twins>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter wrote:
> I see two use-cases:
> 
>  - Isolation
>  - NUMA node devices

Ok ... so let me propose an entirely different solution.

No doubt it has some terrible flaw, but I'll just have to
await your replies to see what that is.

How about we have:

 1) Yet another text config file in /etc, this one containing
    lines having two fields:
	* a list of IRQs, and
	* a cpumask.
    This file would specify which CPUs should handle which IRQs.

 2) A utility that can be run, after changing the above file, 
    to poke the proper cpumask to each IRQ, as specified in
    the file.

(Obligatory "simple" marketing claim: the above requires no
kernel changes.)

What am I missing?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
