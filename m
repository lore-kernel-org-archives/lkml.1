Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbZDZQqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbZDZQqF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 12:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbZDZQpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 12:45:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50469 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755406AbZDZQpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 12:45:24 -0400
Date: Sun, 26 Apr 2009 09:29:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tim Abbott <tabbott@MIT.EDU>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 01/15] Add new HEAD_TEXT_SECTION macro.
In-Reply-To: <1240711870-30505-1-git-send-email-tabbott@mit.edu>
Message-ID: <alpine.LFD.2.00.0904260925330.25154@localhost.localdomain>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <1240711870-30505-1-git-send-email-tabbott@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 25 Apr 2009, Tim Abbott wrote:
>
> This patch is preparation for replacing all uses of ".head.text" or
> ".text.head" in the kernel with macros, so that the section name can
> later be changed without having to touch a lot of the kernel.

I took the "trivially obvious" parts of this patch series - the ones that 
were basically trivial one-liner cleanups (in addition to the first patch 
that was needed for them, of course).

Anything that renamed files and did other infrastructure things (x86) or 
that had vmlinux.lds.S files that didn't match the nice pattern I'd much 
rather take as series of patches that first clean up the infrastructure 
and then do the replacement.

		Linus
