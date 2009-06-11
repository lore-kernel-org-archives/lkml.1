Return-Path: <linux-kernel-owner+w=401wt.eu-S1762125AbZFKDbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762125AbZFKDbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 23:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbZFKDb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 23:31:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64514 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961AbZFKDb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 23:31:26 -0400
Date: Wed, 10 Jun 2009 23:31:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: [GIT PULL] tracing/urgent for v2.6.31
In-Reply-To: <alpine.LFD.2.01.0906102002260.6847@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0906102327050.30552@gandalf.stny.rr.com>
References: <20090610230450.GA8964@elte.hu> <alpine.LFD.2.01.0906102002260.6847@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 10 Jun 2009, Linus Torvalds wrote:
> 
> I think defaulting CONFIG_FTRACE to 'y' is dubious too, but at least 
> that's not a new feature as much as a new config option making other 
> config options visible. But again, I do think it should likely default to 
> off, even so.

Well it was:

	default y if DEBUG_KERNEL

Where the rational was that if you want to debug the kernel, you might 
want to see some tracing features that are available to you.

-- Steve

