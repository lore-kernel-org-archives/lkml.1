Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbZD0QtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbZD0QtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 12:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbZD0Qsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 12:48:53 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:34877 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754352AbZD0Qsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 12:48:52 -0400
Date: Mon, 27 Apr 2009 12:46:21 -0400 (EDT)
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
       David Howells <dhowells@redhat.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 05/15] arm: convert to use __HEAD and HEAD_TEXT macros.
In-Reply-To: <20090426111924.GD28642@uranus.ravnborg.org>
Message-ID: <alpine.DEB.1.10.0904271121280.1665@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <1240711870-30505-1-git-send-email-tabbott@mit.edu> <1240711870-30505-2-git-send-email-tabbott@mit.edu> <1240711870-30505-3-git-send-email-tabbott@mit.edu> <1240711870-30505-4-git-send-email-tabbott@mit.edu>
 <1240711870-30505-5-git-send-email-tabbott@mit.edu> <20090426111924.GD28642@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Apr 2009, Sam Ravnborg wrote:

> > -	.text.head : {
> > +	HEAD_TEXT_SECTION : {
> 
> Spell it out direct rather than hiding the .head.text
> behind a macro name here.

Does .head.text actually need its own output section here?  I notice that 
only the linker scripts for arm, x86, and ia64 have an output section for 
.head.text; the rest just place it at the start of the .text or .init.text 
output section.  It would be great if we could eliminate these extra 
references to .head.text by doing the same thing here.

	-Tim Abbott
