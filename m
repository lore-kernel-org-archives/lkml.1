Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZAAJ4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZAAJ4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 04:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755840AbZAAJ4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 04:56:14 -0500
Received: from phunq.net ([64.81.85.152]:36717 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755688AbZAAJ4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 04:56:13 -0500
From: Daniel Phillips <phillips@phunq.net>
To: tux3@tux3.org
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Date: Thu, 1 Jan 2009 01:56:02 -0800
User-Agent: KMail/1.9.5
Cc: sniper <s3c24xx@gmail.com>, linux-fsdevel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>, Dave Chinner <david@fromorbit.com>,
       linux-kernel@vger.kernel.org
References: <200812301935.49303.phillips@phunq.net> <200812310140.49503.phillips@phunq.net> <9bd6b5360812311014l4b36ddcfj45f1b3e6103ca793@mail.gmail.com>
In-Reply-To: <9bd6b5360812311014l4b36ddcfj45f1b3e6103ca793@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901010156.03279.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 December 2008 10:14, sniper wrote:
> Sorry I meet another problem. After the system was completely setupped,
> the gdb interface will be covered with that system interaction interface.
> So, I can't stop the system's running and add some new break point etc.
> But I can do those operations in remote kgdb debugging.
> 
> Any method to fix this problem?
> 
> Thanks.

I haven't figured that one out.  Usually I get into gdb from uml by
setting a breakpoint, fielding a crash, or executing an explicit
breakpoint: asm("int3").  But I have been unsuccessful so far in
breaking a running uml into the debugger from outside, ever since
SKAS arrived.

Regards,

Daniel
