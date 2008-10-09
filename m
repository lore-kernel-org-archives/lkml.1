Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYJIAIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYJIAIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 20:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755432AbYJIAIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 20:08:00 -0400
Received: from xenotime.net ([66.160.160.81]:43905 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754142AbYJIAH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 20:07:58 -0400
Date: Wed, 8 Oct 2008 17:07:51 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: mtrr_cleanup update command line
Message-Id: <20081008170751.6d86b8e2.rdunlap@xenotime.net>
In-Reply-To: <20080930165739.7847be37.rdunlap@xenotime.net>
References: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com>
	<20080930165739.7847be37.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 16:57:39 -0700 Randy Dunlap wrote:

> On Tue, 30 Sep 2008 16:29:38 -0700 Yinghai Lu wrote:
> 
> > change enable_mtrr_cleanup to mtrr-cleanup, disable_mtrr_cleanup to nomtrr-cleanup.
> > 
> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> > 
> > ---
> >  Documentation/kernel-parameters.txt |    4 ++--
> >  arch/x86/Kconfig                    |    2 +-
> >  arch/x86/kernel/cpu/mtrr/main.c     |    4 ++--
> >  3 files changed, 5 insertions(+), 5 deletions(-)
> > 
> > Index: linux-2.6/Documentation/kernel-parameters.txt
> > ===================================================================
> > --- linux-2.6.orig/Documentation/kernel-parameters.txt
> > +++ linux-2.6/Documentation/kernel-parameters.txt
> > @@ -614,8 +614,8 @@ and is between 256 and 4096 characters.
> >  			See drivers/char/README.epca and
> >  			Documentation/digiepca.txt.
> >  
> > -	disable_mtrr_cleanup [X86]
> > -	enable_mtrr_cleanup [X86]
> > +	nomtrr-cleanup [X86]
> > +	mtrr-cleanup [X86]
> >  			The kernel tries to adjust MTRR layout from continuous
> >  			to discrete, to make X server driver able to add WB
> >  			entry later. This parameter enables/disables that.
> 
> Looks like Documentation/kernel-parameters.txt needs a comment that says that
> entries are supposed to be listed in alphabetical order, not grouped by <subject>.
> Please don't add them like this.

BTW, this comment is alread in Documentation/kernel-parameters.txt, at the top of the file:

The following is a consolidated list of the kernel parameters as implemented
(mostly) by the __setup() macro and sorted into English Dictionary order
(defined as ignoring all punctuation and sorting digits before letters in a
case insensitive manner), and with descriptions where known.


> E.g., the "apic" entries are not grouped together and these mtrr entries should
> not be grouped together unless they all begin with "mtrr", which is an option here:
> they could be renamed to "mtrr-cleanup" and "mtrr-nocleanup".
> And "disable_mtrr_trim" could be renamed to "mtrr-notrim".

---
~Randy
