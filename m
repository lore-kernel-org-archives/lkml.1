Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbYARBh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbYARBh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 20:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYARBhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 20:37:17 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbYARBhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 20:37:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
X-Fcc: ~/Mail/linus
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Use v8086_mode helper, trivial unification
In-Reply-To: Harvey Harrison's message of  Thursday, 17 January 2008 17:15:52 -0800 <1200618952.5724.85.camel@brick>
References: <1200611078.5724.46.camel@brick>
	<478FDE76.3070309@zytor.com>
	<1200612389.5724.63.camel@brick>
	<478FF9F3.9030604@zytor.com>
	<1200618952.5724.85.camel@brick>
X-Windows: warn your friends about it.
Message-Id: <20080118013712.4090526FA0B@magilla.localdomain>
Date: Thu, 17 Jan 2008 17:37:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's indeed true that &pt_regs is truly the esp value for x86-32
kernel-mode trap frames.  Because this nonobvious calculation is 
only right for a kernel mode pt_regs and not for a user-mode one,
I think it would be better to use a name for the inline/macro that
makes this quite clear, rather than one so generic as "stack_addr".

> I think this comes out of Roland's patches unifying some names eip/rip,
> eax/rax, etc.
> 
> CC'd in case he felt like more work ;-)

That was hpa, not me.  Harmonizing the signedness of the struct members
does seem to me like a reasonable and deobfuscatory thing to do.
But I don't plan to get involved in doing it.


Thanks,
Roland
