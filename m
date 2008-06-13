Return-Path: <linux-kernel-owner+w=401wt.eu-S1751221AbYFMSOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbYFMSOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 14:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYFMSNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 14:13:43 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:59194 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbYFMSNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 14:13:41 -0400
Date: Fri, 13 Jun 2008 20:14:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@codemonkey.org.uk>,
       Roland McGrath <roland@redhat.com>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: Additional kconfig targets (cloneconfig, nonint_oldconfig etc)
Message-ID: <20080613181423.GA17930@uranus.ravnborg.org>
References: <20080429183531.GB19652@uranus.ravnborg.org> <20080502190949.GA30270@uranus.ravnborg.org> <20080521164703.61c7d715@ephemeral> <20080521214723.GB15136@uranus.ravnborg.org> <20080613141049.0fb3a770@ephemeral>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613141049.0fb3a770@ephemeral>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 02:10:49PM -0400, Andres Salomon wrote:
> On Wed, 21 May 2008 23:47:23 +0200
> Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Wed, May 21, 2008 at 04:47:03PM -0400, Andres Salomon wrote:
> > > On Fri, 2 May 2008 21:09:49 +0200
> > > Sam Ravnborg <sam@ravnborg.org> wrote:
> > > 
> > > > With the attached patch you can do:
> > > > 
> > > > make K=my_favourite_config defconfig
> > > > 
> > > > kconfig will read all config values form 'my_favourite_config'
> > > > and set all other symbols to their default value.
> > > > The output is now dense like this:
> > > > # configuration is based on 'my_favourite_config'
> > > > #
> > > > # configuration written to .config
> > > > #
> > > > 
> > > 
> > > 
> > > Is this slated for 2.6.27?
> > 
> > Been busy and got sidetracked after my first version proved broken.
> > Will try to look at it in the weekend.
> > 
> > 	Sam
> 
> 
> Any updates on this?  I've been forced to use a workaround in the
> meantime..
Nope. I have been busy with other stuff and need to close this first.
Pending stuff before this:

-> Simplify link of vmlinux (about to be dropped for now as I cannot solve um issue)
-> Kill need for ALTARCH in sparc (almost finished)
-> Optimize make headers_* (almost finished)

And a few more things that I cannot remember atm

	Sam
