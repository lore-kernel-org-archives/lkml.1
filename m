Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbXJYCYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbXJYCYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 22:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755255AbXJYCXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 22:23:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33603 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbXJYCXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 22:23:38 -0400
Date: Wed, 24 Oct 2007 19:19:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>,
       Simon Arlott <simon@fire.lp0.eu>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
 static interface)
Message-ID: <20071024191933.53094b81@laptopd505.fenrus.org>
In-Reply-To: <20071025004128.GC3660@sequoia.sous-sol.org>
References: <20071024223124.GI30533@stusta.de>
	<446110.89443.qm@web36608.mail.mud.yahoo.com>
	<20071024233200.GJ30533@stusta.de>
	<alpine.LFD.0.999.0710241636010.30120@woody.linux-foundation.org>
	<20071025004128.GC3660@sequoia.sous-sol.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 17:41:28 -0700
Chris Wright <chrisw@sous-sol.org> wrote:

> * Linus Torvalds (torvalds@linux-foundation.org) wrote:
> > Do other people want to stand up and be "LSM maintainers" in the
> > sense that they also end up being informed members who can also
> > stand up for new modules and help merge them, rather than just push
> > the existing one(s)? Chris? Casey? Crispin?
> 
> Stephen and James, despite their clear bias towards SELinux, do try to
> give good feedback.  But you are right, there's not enough active help
> for people trying to make a contribution to get their code in shape.
> Many of the modules that come along have been misguided conceptually,
> but I think that e.g. apparmor, tomoyo, smack could use that kind
> of constructive help to get into final mergable shape.  Personally,
> I haven't spent nearly enough time reviewing those, my apologies to
> those developers.  So, yes, help is welcome.
> 

I'll be happy to help out; I'd consider my self neutral in this space
not having worked with any of the LSM out there. I do think we need to
be somewhat critical to what we accept; we should at least be able to
filter out "pretend security" somehow. (this is not the same as saying
that you're bad if you only provide a limited security, in the
contrary, I strongly believe in simple pieces. What I mean is that we
should be critical to things that appear/claim to be strong but are
not).

Secondly, we should make sure that no new holes are added (the original
SMACK series suffered from this, Al Viro helped getting that reviewed
bigtime).

In addition we probably should strive to getting some sort of rough
"this is sort of where we draw the line" guideline set up, just to keep
things more objective.

(Oh and of course, if a security module is deeply involved in another
kernel subsystem, say networking or the VFS, very obviously we should
consult and listen to the respective maintainers of that subsystem; LSM
is not there to be a big hook to bypass the process of well maintained
subsystems)

