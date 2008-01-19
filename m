Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbYASWnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbYASWnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 17:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbYASWnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 17:43:10 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:57815 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbYASWnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 17:43:10 -0500
Date: Sat, 19 Jan 2008 23:43:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [updated PATCH] xen: fix section usage in xen-head.S and setup.c
Message-ID: <20080119224317.GA29768@uranus.ravnborg.org>
References: <200801181318.30009.toralf.foerster@gmx.de> <20080118122917.GH2559@hacking> <20080118124627.GA17918@uranus.ravnborg.org> <20080118125144.GI2559@hacking> <20080118132242.GA18183@uranus.ravnborg.org> <20080118161452.GJ2559@hacking> <20080119131743.GA26615@uranus.ravnborg.org> <20080119212019.GB29070@uranus.ravnborg.org> <47927877.5090209@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47927877.5090209@citrix.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2008 at 02:23:51PM -0800, Jeremy Fitzhardinge wrote:
> Sam Ravnborg wrote:
> >Failing to specify "ax" in the pushsection caused ld to generate
> >an additional section for .init.text appending a number.
> >  
> 
> Thanks for tracking this down.  I think the "ax" appeared and 
> disappeared over time, but this looks like the proper solution.
> 
> Are you going to submit this, or do you want me to pick it up?

Please pick it up as this is xen specific.

	Sam
