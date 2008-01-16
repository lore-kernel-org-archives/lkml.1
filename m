Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbYAPKRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbYAPKRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 05:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYAPKRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 05:17:44 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55182 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbYAPKRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 05:17:43 -0500
Date: Wed, 16 Jan 2008 11:17:47 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: What's in sh-2.6.git for 2.6.25?
Message-ID: <20080116101747.GA26235@uranus.ravnborg.org>
References: <20080116070403.GA14107@linux-sh.org> <20080116073844.GA25205@uranus.ravnborg.org> <20080116093718.GB14107@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080116093718.GB14107@linux-sh.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 06:37:18PM +0900, Paul Mundt wrote:
> On Wed, Jan 16, 2008 at 08:38:44AM +0100, Sam Ravnborg wrote:
> > On Wed, Jan 16, 2008 at 04:04:03PM +0900, Paul Mundt wrote:
> > > This is a brief summary of the changes that are sitting in the sh queue
> > > for 2.6.25.
> > > 
> > > The main points to note are as follows:
> > > 
> > > 	- sh64->sh integration.
> > > 	- A handful of new CPUs (SH7721, SH7763, SH7203, SH7263).
> > > 	- SH-2A FPU support.
> > > 	- Board support updates (R2D, R7785RP).
> > > 
> > > The sh64->sh integration is basically the only thing that's really
> > > interesting, and so it's worth summarizing that a bit.
> > 
> > Any kbuild bits that needs an extra pair of eyes before
> > integration or can I postpone my review until it hits mainline?
> > If you feel confident I prefer to wait as I'm busy atm.
> > 
> Most of the kbuild bits have been pretty painless. I started out going
> the SRCARCH route, but that ended up creating a lot of additional
> duplication, so I opted to just roll them together and stick with abusing
> KCONFIG_ALLCONFIG for restricting the options. Based on the heavy sharing
> between the Kconfig options, this seemed to be the best way to go.
> 
> So, I'm reasonably content with it the way it is, but any input you have
> on cleaning it up is certainly welcome at any time :-)

I will take a look when it hits mainline then.
Ping me if you do not hear from me.

	Sam
