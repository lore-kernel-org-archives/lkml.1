Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbZJZX0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbZJZX0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbZJZX0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:26:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48016 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbZJZX03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:26:29 -0400
Subject: Re: [RFC] to rebase or not to rebase on linux-next
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Nicolas Pitre <nico@fluxnic.net>, "Luck, Tony" <tony.luck@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Robert Richter <robert.richter@amd.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20091023215958.GA4139@merkur.ravnborg.org>
References: <20091022122042.e535d43c.sfr@canb.auug.org.au>
	 <20091023112732.GB5886@elte.hu> <4AE19A74.1090709@garzik.org>
	 <20091023123555.GA25366@elte.hu>
	 <57C9024A16AD2D4C97DC78E552063EA3E33D0174@orsmsx505.amr.corp.intel.com>
	 <20091023134115.GD27097@elte.hu>
	 <alpine.LFD.2.00.0910231424440.21460@xanadu.home>
	 <20091023191631.GA1879@elte.hu>
	 <1256326512.26028.34.camel@gandalf.stny.rr.com>
	 <20091023205400.GA8356@elte.hu> <20091023215958.GA4139@merkur.ravnborg.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 26 Oct 2009 19:26:28 -0400
Message-Id: <1256599588.26028.340.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-23 at 23:59 +0200, Sam Ravnborg wrote:
> On Fri, Oct 23, 2009 at 10:54:00PM +0200, Ingo Molnar wrote:
> > 
> > Maintainer trees pushed towards linux-next should strive to be Git 
> > based, append-mostly, 'nice', 'intended for upstream' and defendable 
> > as-is IMO, and rebasing a _maintainer tree_ should really be a rare act 
> > of last resort.
> 
> As maintainer I try to put some effort in crediting people
> where credit belongs.
> In other words collecting "Acked-by:", "Tested-by", "Reviewed-by".
> 
> Adding this require a rebase as soon as said patch hits git.

I've been saying for a while that git really needs a way to "annotate" a
commit. And have git log show those annotations by default.
Signed-off-by must be in the original commit. But Acked-by, Tested-by
and Reviewed-by almost always come after it hits some git repo.

Thus, if we could add an annotation to a commit later, that would be
very helpful. We could add these other labels on.

For Acked-by, when needed (touching a Maintainers code) I usually send
out an RFC patch set first to get these. But for Reviewed-by and
Tested-by which usually come after I have it in my git tree and I push
it off to Ingo, those come later. And unfortunately, I seldom get to add
those tags.

I think this is more of a failure in git than in the work flow we
present.

-- Steve


