Return-Path: <linux-kernel-owner+w=401wt.eu-S1760030AbYJJN1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030AbYJJN1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 09:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbYJJN1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 09:27:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34136 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbYJJN1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 09:27:37 -0400
Date: Fri, 10 Oct 2008 09:27:34 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Anders Kaseorg <andersk@MIT.EDU>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] ftrace: Make ftrace_test_p6nop disassembler-friendly
In-Reply-To: <20081010085429.GB319@elte.hu>
Message-ID: <alpine.DEB.1.10.0810100927110.26408@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0810092209460.21569@vinegar-pot.mit.edu> <20081010085429.GB319@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 10 Oct 2008, Ingo Molnar wrote:

> 
> * Anders Kaseorg <andersk@MIT.EDU> wrote:
> 
> > Commit 4c3dc21b136f8cb4b72afee16c3ba7e961656c0b in tip introduced the
> > 5-byte NOP ftrace_test_p6nop:
> >   jmp . + 5
> >   .byte 0x00, 0x00, 0x00
> > This is not friendly to disassemblers because an odd number of 0x00s
> > ends in the middle of an instruction boundary.  This changes the 0x00s
> > to 1-byte NOPs (0x90).
> > 
> > Signed-off-by: Anders Kaseorg <andersk@mit.edu>
> 
> applied to tip/tracing/ftrace, good spotting Anders!
> 
> Steve, any objections?

Nope, it's fine with me.

Acked-by: Steven Rostedt <srostedt@redhat.com>

