Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZBZKDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZBZKDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 05:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbZBZKDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 05:03:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:36266 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbZBZKDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 05:03:44 -0500
Subject: Re: [PATCH v2 0/5] [RFC] copy_strtok_from_user
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20090226053240.607719846@goodmis.org>
References: <20090226053240.607719846@goodmis.org>
Content-Type: text/plain
Date: Thu, 26 Feb 2009 11:03:32 +0100
Message-Id: <1235642612.4645.4737.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 00:32 -0500, Steven Rostedt wrote:
> This is the second series of the uaccess code.
> 
> Changes in v2:
> 
>  - moved probe_kernel_* functions to lib/uaccess.c
> 
>  - renamed copy_word_from_user to copy_strtok_from_user.
> 
>  - changed copy_strtok_from_user to pass in a delimiter string.
>    ftrace defines SPACE to be ' \t\r\n'.
> 
> Ingo,
> I added your copy right to lib/uaccess.c since git blame shows you
> as the author of the probe_kernel_* code. Also, is it OK that I
> added the "GPL v2" line in that file as well?
> 
> Andrew,
> Since you are, in essence, the memory maintainer, could you give
> your Acked-by: to the copy_strtok_from_user code.
> 
> The probe_kernel code is still EXPORT_SYMBOL_GPL, and I added
> that too to copy_strtok_from_user. Are there any objections to that?

I have to ask,..

cant this be done with a regular copy_from_user() followed by a regular
strtok()? Do we really have to combine all that?

