Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbZJZFVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbZJZFVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 01:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZJZFVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 01:21:23 -0400
Received: from THUNK.ORG ([69.25.196.29]:40838 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754638AbZJZFVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 01:21:23 -0400
Date: Mon, 26 Oct 2009 01:21:18 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] to rebase or not to rebase on linux-next
Message-ID: <20091026052118.GB13941@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Nicolas Pitre <nico@fluxnic.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jeff Garzik <jeff@garzik.org>,
	Robert Richter <robert.richter@amd.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jean Delvare <khali@linux-fr.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <4AE19A74.1090709@garzik.org> <20091023123555.GA25366@elte.hu> <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com> <20091023134115.GD27097@elte.hu> <alpine.LFD.2.00.0910231424440.21460@xanadu.home> <20091023191631.GA1879@elte.hu> <1256326512.26028.34.camel@gandalf.stny.rr.com> <20091023205400.GA8356@elte.hu> <20091024080326.GA7461@mit.edu> <57C9024A16AD2D4C97DC78E552063EA3E33D0A53@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E33D0A53@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 25, 2009 at 09:53:41PM -0700, Luck, Tony wrote:
> 
> If the "rewind" is simply to add "signed-off-by" notations, update
> commit comments (or code comments) ... then it does seem useful to
> keep the commit chain anchored to the original commit, as the testing
> that has been done is all still valid.
> 
> But as soon as you talk about fixing bugs ... then you ought to
> just do a "rebase".  The code you are adding has changed, so it is
> incorrect to preserve the illusion that these changes have had
> extensive testing against the old commit base.  The code has changed,
> so the testing clock gets reset to zero.

I don't think anyone should (or does?) use the base version of a patch
series as an indication of how much testing a patch series has
received.  It doesn't make much sense.

Suppose I update the 40th patch of a 50th patch series to add check
for kmalloc() returning NULL that had been inadvertently left out, or
some other error checking is added.  Or suppose I add a new tracepoint
definition to a 50 patch series.  Sorry, I'm not going to rewind the
entire patch series because someone thinks the base version of the
patch series somehow is a magic "test clock" indicator....

      	     	     	  	      	     - Ted
