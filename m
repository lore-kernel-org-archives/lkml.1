Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbYKLXZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbYKLXZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbYKLXZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:25:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65340 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbYKLXZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:25:37 -0500
Date: Wed, 12 Nov 2008 18:25:35 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] tracing/function-return-tracer: Call prepare_ftrace_return
 by registers
In-Reply-To: <c62985530811121422w6d33de3cp506bdf1aa96efd81@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811121824380.21116@gandalf.stny.rr.com>
References: <491B4F63.3090909@gmail.com> <20081112221623.GB6125@elte.hu> <c62985530811121422w6d33de3cp506bdf1aa96efd81@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 12 Nov 2008, Fr?d?ric Weisbecker wrote:

> 2008/11/12 Ingo Molnar <mingo@elte.hu>:
> >
> > btw., should we now rename it all to the function-cost tracer?
> 
> Yes. I'm preparing a patch to do these renames....

I still need to look deeper at your patch set, but what about 
"ftrace-exit"?  Perhaps in the future this could be used by other tracers 
to record exiting of a function.

-- Steve

