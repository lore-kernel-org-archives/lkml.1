Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbZJ0SeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbZJ0SeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 14:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbZJ0SeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 14:34:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65317 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339AbZJ0SeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 14:34:03 -0400
Subject: Re: [PATCH] [GIT PULL] tracing: allow to change permissions for
 text with dynamic ftrace enabled
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1256671227.2691.15.camel@sbs-t61.sc.intel.com>
References: <1256666023.26028.411.camel@gandalf.stny.rr.com>
	 <1256671227.2691.15.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 27 Oct 2009 14:33:58 -0400
Message-Id: <1256668438.26028.414.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 11:20 -0800, Suresh Siddha wrote:

> Steven, Is it possible for dynamic ftrace to use the kernel identity
> mapping instead of the kernel text mapping for converting the tracing
> calls to nops etc.

Not sure what you mean by "kernel identity" mapping.

> 
> That way, we can still retain large page mappings for kernel text, while
> allowing the text to be changed.
> 
> I need to think through this to see if there are any subtle issues. What
> do you think?

Yeah, this is for now the quick fix. But I'm sure there can be better
changes to fix this.

-- Steve


