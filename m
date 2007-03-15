Return-Path: <linux-kernel-owner+w=401wt.eu-S933932AbXCPApq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933932AbXCPApq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 20:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933941AbXCPApq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 20:45:46 -0400
Received: from ozlabs.org ([203.10.76.45]:44584 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933932AbXCPApp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 20:45:45 -0400
Subject: Re: [PATCH take3 00/20] Make common x86 arch area for i386 and
	x86_64 - Take 3
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>
In-Reply-To: <20070315051337.488091591@goodmis.org>
References: <20070315051337.488091591@goodmis.org>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 17:37:39 +1100
Message-Id: <1173940659.19022.79.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-15 at 01:13 -0400, Steven Rostedt wrote:
> Once again here's an attempt to put the shared files of x86_64 and i386
> into a separate directory.

OK, that's fine, but the next step is to have "make ARCH=x86" compile,
with a config option as to whether to build 32 or 64 bit.  This will
involve a fair amount of Makefile hair, but if you can get Andi to buy
into that then the rest is a simple matter of code churn.  For most
kernel hackers, this would be the flag day.

Moving the rest of the files across to xxx_32.c, xxx_64.h etc is going
to involve a great deal of untangling and code cleanup.  It's also going
to completely screw a whole heap of my cleanup patches.  Oh well.

(Still hoping for an executive summary from the PPC folks).

Cheers!
Rusty.


