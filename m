Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYLVXyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYLVXyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbYLVXyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:54:46 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:38185 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbYLVXyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:54:46 -0500
Subject: Re: [PATCH 0/9] oprofile: port to the new ring buffer
From: Carl Love <cel@us.ibm.com>
To: Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
In-Reply-To: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
References: <1229013723-8191-1-git-send-email-robert.richter@amd.com>
Content-Type: text/plain
Date: Mon, 22 Dec 2008 15:53:39 -0800
Message-Id: <1229990019.13485.0.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have tested  the new ring buffer patches on an IBM Cell blade.  Our
OProfile testsuite ran fine on the the patched kernel. I ran the
testsuite three times yesterday/last night.  As far as I can tell
the new code works fine.

Note, I started with a 2.6.28-rc7 kernel from kernel.org.  I then
applied the the ftrace series of patches followed by the ring buffer
patches.  I then had to explicitly enable the tracing in the .config
file as there is now a dependency on that.  Robert updated the OProfile
dependency stuff yesterday.  I started with my .config file that I have
used for building kernels on my cell machine.

                       Carl Love

On Thu, 2008-12-11 at 17:41 +0100, Robert Richter wrote:
> This patch set ports cpu buffers in oprofile to the new ring buffer
> provided by the tracing framework. The motivation here is to leave the
> pain of implementing ring buffers to others. Oh, no, there are more
> advantages. Main reason is the support of different sample sizes that
> could be stored in the buffer. Use cases for this are IBS and Cell spu
> profiling. Using the new ring buffer ensures valid and complete
> samples and allows copying the cpu buffer stateless without knowing
> its content. Second it will use generic kernel API and also reduce
> code size. And hopefully, there are less bugs.
> 
> The patch set is also available here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git ring_buffer
> 
> -Robert
> 
> 
> 
> 
> ------------------------------------------------------------------------------
> SF.Net email is Sponsored by MIX09, March 18-20, 2009 in Las Vegas, Nevada.
> The future of the web can't happen without you.  Join us at MIX09 to help
> pave the way to the Next Web now. Learn more and register at
> http://ad.doubleclick.net/clk;208669438;13503038;i?http://2009.visitmix.com/
> _______________________________________________
> oprofile-list mailing list
> oprofile-list@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/oprofile-list

