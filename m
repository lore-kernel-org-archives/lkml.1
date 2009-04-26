Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbZDZScM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbZDZScM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 14:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZDZSb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 14:31:57 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:47723 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZDZSb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 14:31:56 -0400
Date: Sun, 26 Apr 2009 20:34:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tim Abbott <tabbott@MIT.EDU>,
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
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       David Howells <dhowells@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 14/15] x86: convert to use __HEAD and HEAD_TEXT macros.
Message-ID: <20090426183401.GA1622@uranus.ravnborg.org>
References: <1240711870-30505-7-git-send-email-tabbott@mit.edu> <1240711870-30505-8-git-send-email-tabbott@mit.edu> <1240711870-30505-9-git-send-email-tabbott@mit.edu> <1240711870-30505-10-git-send-email-tabbott@mit.edu> <1240711870-30505-11-git-send-email-tabbott@mit.edu> <1240711870-30505-12-git-send-email-tabbott@mit.edu> <1240711870-30505-13-git-send-email-tabbott@mit.edu> <1240711870-30505-14-git-send-email-tabbott@mit.edu> <alpine.LFD.2.00.0904260934570.3101@localhost.localdomain> <alpine.LFD.2.00.0904260958190.3101@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904260958190.3101@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 10:12:47AM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 26 Apr 2009, Linus Torvalds wrote:
> > 
> > Btw, this one really needs to unify the two lds files first. Look at 
> > 
> > 	diff -u arch/x86/boot/compressed/vmlinux_*.lds
> > 
> > output and realize that they're basially exctly the same except for 
> > trivial naming differences, and the fact that the64-bit version hs a 
> > "pgtable" thing.
> > 
> > So this really needs to be done by first unifying the thing so that there 
> > is _one_ arch/x86/boot/compressed/vmlinux.lds.S file with a preprocessor 
> > that takes care of the trivial differences [..]
> 
> Something like this?

Looks good/correct.
Acked-by: Sam Ravnborg <sam@ravnborg.org>

You should add your s-o-b if you expect Ingo to pick it up.

	Sam
