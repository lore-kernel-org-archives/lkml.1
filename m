Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbZBFN3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbZBFN3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 08:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbZBFN3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 08:29:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63399 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbZBFN3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 08:29:40 -0500
Date: Fri, 6 Feb 2009 08:29:39 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Michael Neuling <mikey@neuling.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ftrace, powerpc: replace debug macro with proper
 pr_deug
In-Reply-To: <1233903912.4612.120.camel@pasglop>
Message-ID: <alpine.DEB.1.10.0902060828050.10059@gandalf.stny.rr.com>
References: <20090206060328.181057235@goodmis.org>  <20090206060527.148611255@goodmis.org> <1233903912.4612.120.camel@pasglop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 6 Feb 2009, Benjamin Herrenschmidt wrote:

> On Fri, 2009-02-06 at 01:03 -0500, Steven Rostedt wrote:
> > plain text document attachment
> > (0001-ftrace-powerpc-replace-debug-macro-with-proper-pr_.patch)
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Impact: cleanup
> > 
> > The PowerPC ftrace code uses a hacked up DEBUGP macro for prints.
> > This patch converts it to the standard pr_debug.
> >
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 
> Want me to go through powerpc tree or you'll merge via Ingo ?

These two changes are powerpc specific. I think it may get more testing 
going through the powerpc tree than through tip.

-- Steve

