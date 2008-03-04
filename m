Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbYCDG1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbYCDG1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbYCDG06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:26:58 -0500
Received: from relay2.sgi.com ([192.48.171.30]:46515 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751316AbYCDG05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:26:57 -0500
Date: Tue, 4 Mar 2008 00:26:51 -0600
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: a.p.zijlstra@chello.nl, maxk@qualcomm.com, mingo@elte.hu,
       tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-Id: <20080304002651.95089ff1.pj@sgi.com>
In-Reply-To: <6599ad830803032221j740c9657yec237ebbadbeaeaa@mail.gmail.com>
References: <20080227222103.673194000@chello.nl>
	<47C8771C.1070001@qualcomm.com>
	<1204545445.11412.6.camel@twins>
	<20080303113621.1dfdda87.pj@sgi.com>
	<1204567052.6241.4.camel@lappy>
	<20080303121033.c8c9651c.pj@sgi.com>
	<6599ad830803031041r6c635141n6520a915f2e1d08@mail.gmail.com>
	<20080303125253.5d2d580c.pj@sgi.com>
	<6599ad830803032126m39935eaeu1df67d6263e8e123@mail.gmail.com>
	<20080304001507.3ddc8f26.pj@sgi.com>
	<6599ad830803032221j740c9657yec237ebbadbeaeaa@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> Except that this isn't currently possible if you're also trying to do
> memory hardwalling on those cpusets, since then sibling cpusets can't
> share memory nodes.
 
Yes, there would be interactions, on both the CPU and Memory side with
some second order mechanisms (hardwalls and sched domains.)

Still, I ask, where's the beef -- the real users?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
