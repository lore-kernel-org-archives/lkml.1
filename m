Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbYHCOpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbYHCOpY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 10:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbYHCOpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 10:45:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63381 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbYHCOpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 10:45:08 -0400
Date: Sun, 3 Aug 2008 10:45:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ming Lei <tom.leiming@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC] ftrace: support tracing functions in one module
In-Reply-To: <d82e647a0808030050n3b72d96dh91c0ac94eadc34f@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0808031042440.30870@gandalf.stny.rr.com>
References: <d82e647a0808030050n3b72d96dh91c0ac94eadc34f@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 3 Aug 2008, Ming Lei wrote:

> Hi,
> 
> IMO, ftrace is a very good tools, which can monitor almost all
> functions calling
> in the running kernel. The traced result is very complete and intact.
> But it seems
> too large to grasp the interested content.  For example, one may only
> have interest in
> functions calling in usbcore.ko, but he must trace all the functions
> calling in the
> kernel, so the tracing result is too large to use it.
> 
> Could you add the support of tracing functions in one module only to ftrace?

Look at the set_ftrace_filter in ftrace.txt. You can pick and choose which 
functions to trace.  All the functions that can be traced is in 
available_filter_functions in the debugfs/tracing directory.

Note, the functions must execute at least once before they can be 
recorded.

-- Steve

