Return-Path: <linux-kernel-owner+w=401wt.eu-S1763509AbYALBhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763509AbYALBhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 20:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762613AbYALBht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 20:37:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762427AbYALBhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 20:37:48 -0500
Message-ID: <478819EA.2080905@redhat.com>
Date: Fri, 11 Jan 2008 20:37:46 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Vineet Gupta <vineetg76@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Usage semantics of atomic_set ( )
References: <9f4f8abe0801111457t7535069ar1f98cc37d5cf8d40@mail.gmail.com>
In-Reply-To: <9f4f8abe0801111457t7535069ar1f98cc37d5cf8d40@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vineet Gupta wrote:
> I'm trying to implement atomic ops for a CPU which has no inherent
> support for Read-Modify-Write Ops. Instead of using a global spin lock
> which protects all the atomic APIs, I want to use a spin lock per
> instance of atomic_t.

What operations are you using to implement spinlocks?

A few architectures use arrays of spinlocks to implement atomic_t.  I believe 
sparc and parisc are among them.  Assuming your spinlock implementation is sound 
and efficient, the same technique should work for you.

	-- Chris
