Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbYJGRil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbYJGRil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 13:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYJGRid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 13:38:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55054 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752948AbYJGRic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:38:32 -0400
Date: Tue, 7 Oct 2008 13:38:31 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <jason.wessel@windriver.com>, <avi@qumranet.com>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 2/9] x86 architecture implementation of Hardware
 Breakpoint interfaces
In-Reply-To: <20081007172301.GC4130@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0810071337330.2759-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2008, K.Prasad wrote:

> There's been a perceivable inclination to let the user learn the
> limitations/features of the underlying processor's breakpointing ability
> (since the previous email mail thread on this topic) and the routines
> pre_ and post_handler_allowed() are just a step towards that.
> 
> I can nullify the post_handler for x86-instruction breakpoint for now,
> but it wouldn't simplify things very extensively (but for a few lines of
> code in hw_breakpoint_handler() and the flag 'sstep_reason'). It also
> benefits the code by bringing an understanding that there can be
> multiple users of processor single-stepping (and therefore the need to
> de-multiplex the exception and invoke the appropriate handler).
> 
> Left to me, I would like to retain the post_handler routine, unless you
> strongly feel otherwise.

Let's hear what Roland has to say.

Alan Stern

