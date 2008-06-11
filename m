Return-Path: <linux-kernel-owner+w=401wt.eu-S1755849AbYFKGit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849AbYFKGit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 02:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbYFKGik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 02:38:40 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48082 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752757AbYFKGij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 02:38:39 -0400
Date: Wed, 11 Jun 2008 08:39:21 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rob Landley <rob@landley.net>
Cc: Adrian Bunk <bunk@kernel.org>, Tim Bird <tim.bird@am.sony.com>,
       linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: mainlining min-configs...
Message-ID: <20080611063921.GA27978@uranus.ravnborg.org>
References: <48447615.5050806@am.sony.com> <20080610183004.GG11685@cs181133002.pp.htv.fi> <20080610185123.GA15838@uranus.ravnborg.org> <200806110009.22542.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806110009.22542.rob@landley.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > When I get my kconfig patchset polished you will be able to do:
> >
> > make K=my_mini_config allnoconfig
> 
> So you're renaming KCONFIG_ALLNOCONFIG then?

Somehow yes. The K= notation I hope will see more use. Only very few
people know the KCONFIG_ALL*CONFIG= trick.

> 
> > Thus selecting 'no' for all new symbols in an automated fashion.
> > I know that in a few cases 'no' is the wrong answer but in the
> > 99% of the cases 'no' is perfectly valid.
> 
> For a "make miniconfig", warnings should be errors.  (Attempts to set unknown 
> symbols are an error with a miniconfig, the operation should exit with a 
> nonzero error code.)  Also, all the stuff allnoconfig puts to stdout 
> shouldn't be there for miniconfig, only the stuff it writes to stderr right 
> now should show up.

My reference was to a minimal config of a system - not to a miniconfig
as your patcset produces. Just to make it clear.

The patchset I refer will also reduce the nosie generated during make *config.

	Sam
