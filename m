Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYDRNVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYDRNVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 09:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753045AbYDRNVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 09:21:30 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41535 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbYDRNV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 09:21:28 -0400
Date: Fri, 18 Apr 2008 08:21:00 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, crispin@crispincowan.com, serue@us.ibm.com,
       matthew@wil.cx, paul.moore@hp.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       takedakn@nttdata.co.jp, linux-fsdevel@vger.kernel.org
Subject: Re: [TOMOYO #7 30/30] Hooks for SAKURA and TOMOYO.
Message-ID: <20080418132059.GA9011@sergelap.austin.ibm.com>
References: <1208182620.18883.92.camel@moss-spartans.epoch.ncsc.mil> <484889.77284.qm@web36604.mail.mud.yahoo.com> <200804152014.IAB35427.tFLHSMOQOFOFJV@I-love.SAKURA.ne.jp> <20080416191315.GB3923@ucw.cz> <200804172058.BHI60408.OtFFMOJHOLQVSF@I-love.SAKURA.ne.jp> <20080417174656.GA5880@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417174656.GA5880@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Machek (pavel@ucw.cz):
> > 
> > Pavel Machek wrote:
> > > > It is true that namespace may differ between processes,
> > > > but I think that that is the matter of how to restrict namespace manipulation operations.
> > > > As I said, a system can't survive if namespace is madly manipulated.
> > > > To keep the system workable, /bin/ must be the directory for binary programs,
> > > > /etc/ must be the directory for configuration files, and so on in all namespaces.
> > > 
> > > Ehm? Where did you get those ideas?
> > > 
> > > I'm free to name my directories any way I want, and keep config files
> > > in /pavlix_config, thank you... There is even distro that does
> > > something like that, IIRC...
> > > 
> > We can make processes have different namespace by using clone() with CLONE_NEWNS.
> > But even if some process got a different namespace, it need to follow conventional rules.
> > Optional files (e.g. /pavlix_config) need not to follow conventional rules.
> > What I'm talking about is essetial files (e.g. /bin/sh and
> > /etc/passwd).
> 
> Why would I need to follow rules?
> 
> > Can your system continue running even if essetial files are not in place
> > (like /bin/sh moved to /etc/sh and /etc/passwd moved to /bin/passwd) ?
> 
> Why not? They are just a names, they can be changed as log as you
> change them everywhere. Which is rather easy for small
> systems... think openembedded.
> 									Pavel

This is getting silly - if you change them "everywhere" then you can
change them in your security profiles too :)

Anyway this thread has degenerated again.

Crispin, thanks for posting those use cases.

Now the next step IMO is for someone (Tetsuo?) to take one of those use
cases and run through each of the four (was it 4?) proposed methods for
handling the pathnames.  One paragraph describing how the use case in
general would be handled, then a list of shortcomings for the solution.

-serge
