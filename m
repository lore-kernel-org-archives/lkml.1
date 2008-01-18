Return-Path: <linux-kernel-owner+w=401wt.eu-S1760557AbYARLhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760557AbYARLhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 06:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750988AbYARLhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 06:37:40 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:50834 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbYARLhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 06:37:39 -0500
Date: Fri, 18 Jan 2008 12:37:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] x86: allow 64bit setting in Kconfig
Message-ID: <20080118113744.GA17447@uranus.ravnborg.org>
References: <20080117214301.GA28233@does.not.exist> <20080118104401.GA8785@elte.hu> <1200653448.5724.135.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200653448.5724.135.camel@brick>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 02:50:48AM -0800, Harvey Harrison wrote:
> 
> On Fri, 2008-01-18 at 11:44 +0100, Ingo Molnar wrote:
> > * Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > >  # Select 32 or 64 bit
> > >  config 64BIT
> > > -	bool "64-bit kernel" if ARCH = "x86"
> > > +	bool "64-bit kernel"
> > >  	default ARCH = "x86_64"
> > >  	help
> > >  	  Say yes to build a 64-bit kernel - formerly known as x86_64
> > 
> > thx, i've added this to x86.git.
> 
> Style question, would the following be preferred?
> 
> config 64BIT
> 	def_bool ARCH = "x86_64"
> 	prompt "64-bit kernel"
> 	help...

No.
It is most common to let the prompt follow the type and not
as a separate property.

	Sam
