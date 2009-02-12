Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbZBLQfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbZBLQfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 11:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbZBLQfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 11:35:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61927 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbZBLQfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 11:35:31 -0500
Date: Thu, 12 Feb 2009 11:35:30 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 0/7][RFC] function graph tracer port to PowerPC
In-Reply-To: <20090212011051.265346435@goodmis.org>
Message-ID: <alpine.DEB.1.10.0902121132000.15469@gandalf.stny.rr.com>
References: <20090212011051.265346435@goodmis.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 11 Feb 2009, Steven Rostedt wrote:

> 
> The following set of patches are RFC and not for inclusion
> (unless everyone is fine with them as is).
> 
> This is the port to PowerPC of the function graph tracer that was written
> by Frederic Weisbecker for the x86 architecture.  It is broken up
> into a series of logical steps.
> 
> 1) get generic code ready for other archs
> 2) get PowerPC 64-bit working with just static function tracing
> 3) get PowerPC 64-bit working with dynamic function tracing
> 4) get PowerPC 32-bit working with just static function tracing
> 5) get PowerPC 32-bit working with dynamic function tracing
> 
> (with some clean ups in between)

Ben, if you get some time (no rush really), can you give an acked-by
on each of the PPC patches. The first patch is ftrace generic, so
you can ignore that one.

I'll keep it in the RFC state, until I have an ack from either you or
Paul.

I'm not sure if these changes should go via you or Ingo. I'm thinking 
that, since the first change modifies core ftrace code, I'll send it 
towards tip, since all the rest depends on that first change.

Thanks,

-- Steve
