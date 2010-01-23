Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588Ab0AWBi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab0AWBi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 20:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304Ab0AWBi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 20:38:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51169
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754323Ab0AWBi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 20:38:27 -0500
Date: Fri, 22 Jan 2010 17:38:38 -0800 (PST)
Message-Id: <20100122.173838.159363288.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: rostedt@goodmis.org, vapier@gentoo.org, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, mingo@redhat.com, brueckner@linux.vnet.ibm.com,
       lethal@linux-sh.org
Subject: Re: [PATCH] ftrace: unify arch_syscall_addr() implementations
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100122163700.GD6412@osiris.boeblingen.de.ibm.com>
References: <1264167826-20913-1-git-send-email-vapier@gentoo.org>
	<1264170977.31321.382.camel@gandalf.stny.rr.com>
	<20100122163700.GD6412@osiris.boeblingen.de.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Fri, 22 Jan 2010 17:37:00 +0100

> On Fri, Jan 22, 2010 at 09:36:17AM -0500, Steven Rostedt wrote:
>> I would not be too sure. s390 is very strange, and I would definitely
>> want to get an Ack from the arch maintainers first.
> 
> It's not a typo. The syscall table on s390 contains always 32 bit pointers
> since we know that the address of the function to be called is (way) below
> 4GB. So this saves us a few bytes.
> In addition this makes syscall patching done by some security modules a
> bit more difficult, since they would need to store a 64 bit pointer.
> That's because we make sure that module addresses are always above 4GB.

Sparc64 is the same way.
