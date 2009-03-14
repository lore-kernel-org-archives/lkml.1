Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbZCNDnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbZCNDnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 23:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbZCNDmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 23:42:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:45037 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZCNDmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 23:42:51 -0400
Subject: Re: [patch 02/11] x86 architecture implementation of Hardware
 Breakpoint interfaces
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ingo Molnar <mingo@elte.hu>, prasad@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <Pine.LNX.4.44L0.0903101620390.4325-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0903101620390.4325-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 14:41:15 +1100
Message-Id: <1237002075.25062.78.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 16:30 -0400, Alan Stern wrote:
> Suppose we never allow callers to register more breakpoints than will
> fit in the CPU's registers.  Do we then use a simple first-come
> first-served algorithm, with no prioritization?  If we do prioritize
> some breakpoint registrations more highly than others, how do we
> inform
> callers that their breakpoint has been kicked out by one of higher
> priority?  And how do we let them know when the higher-priority
> breakpoint has been unregistered, so they can try again?

Do we really need such a mess ? Honestly ... We've been living fine
before without any of that.

Ben.

