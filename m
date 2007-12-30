Return-Path: <linux-kernel-owner+w=401wt.eu-S1756686AbXL2XET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756686AbXL2XET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 18:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbXL2XEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 18:04:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:40066 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbXL2XEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 18:04:05 -0500
Date: Sun, 30 Dec 2007 00:02:17 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Valdis.Kletnieks@vt.edu
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, serue@us.ibm.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: TOMOYO Linux Security Goal
Message-ID: <20071230000217.GA17828@ucw.cz>
References: <200712252133.JFF05267.FOMFtOLJHSOVFQ@I-love.SAKURA.ne.jp> <20071226164230.GA14210@sergelap.austin.ibm.com> <200712272200.IIJ73936.OHOFFLMOQJVFtS@I-love.SAKURA.ne.jp> <20071227145431.GB5161@sergelap.austin.ibm.com> <200712282332.EGC57888.OFFQHJOLVSMtFO@I-love.SAKURA.ne.jp> <27904.1198862631@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27904.1198862631@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2007-12-28 12:23:51, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 28 Dec 2007 23:32:09 +0900, Tetsuo Handa said:
> 
> > You can run your system with only policy collected by learning mode.
> > Thus, you basically don't need manual intervention.
> > But since there are randomly named files (i.e. temporary files),
> > you pay a little time to modify policy.
> > 
> > The learning mode is to save time for permitting commonly accessed resources.
> > Administrator reviews policy collected by learning mode. Thus the readability
> > of policy is important so that administrator can understand what he/she is
> > going to allow or reject.
> 
> Please make a *big* notation someplace that "learning mode" is quite likely to
> *not* produce a totally correct policy.  In particular, it won't build rules for
> infrequently used code paths (such as error handling) unless you find a way to
> exercise those paths while in learning mode.
> 
> Particularly fun - when learning mode doesn't create an entry for the logfile
> for I/O errors.  Then when one actually happens, you have no idea what it was...

Yes... if you disallow access to /etc/nologin (or do something
similary stupid) you can even introduce security hole...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
