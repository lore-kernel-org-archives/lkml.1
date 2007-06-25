Return-Path: <linux-kernel-owner+w=401wt.eu-S1754349AbXFYTH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349AbXFYTH7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 15:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbXFYTHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 15:07:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:48132 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751740AbXFYTHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 15:07:50 -0400
Date: Mon, 25 Jun 2007 17:14:11 +0200
From: Pavel Machek <pavel@suse.cz>
To: Chris Mason <chris.mason@oracle.com>
Cc: James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Lars Marowsky-Bree <lmb@suse.de>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070625151411.GB1018@elf.ucw.cz>
References: <20070621183311.GC18990@elf.ucw.cz> <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain> <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070622003436.GB6222@think.oraclecorp.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain> <20070622121742.GC6222@think.oraclecorp.com> <Line.LNX.4.64.0706220858170.5751@localhost.localdomain> <20070622140240.GM6222@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622140240.GM6222@think.oraclecorp.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> We've been over the "AA is different" discussion in threads about a
> billion times, and at the last kernel summit.  I think Lars and others
> have done a pretty good job of describing the problems they are trying
> to solve, can we please move on to discussing technical issues around
> that?

Actually, I surprised Lars a lot by telling him ln /etc/shadow /tmp/
allows any user to make AA ineffective on large part of systems -- in
internal discussion. (It is not actually a _bug_, but it is certainly
unexpected).

(Does it surprise you, too? I'm pretty sure it would surprise many users).

James summarized it nicely:

# The design of the AppArmor is based on _appearing simple_, but at the
# expense of completeness and thus correctness.

If even Lars can be surprised by AAs behaviour, I do not think we can
say "AA is different". I'm afraid that AA is trap for users. It
appears simple, and mostly does what it is told, but does not do _what
user wants_.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
