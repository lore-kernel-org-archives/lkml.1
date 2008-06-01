Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346AbYFARmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbYFARmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 13:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbYFARmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 13:42:15 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:35560 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbYFARmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 13:42:14 -0400
Date: Sun, 1 Jun 2008 19:42:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Clifford Wolf <clifford@clifford.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add 'make no2modconfig' config generation target
Message-ID: <20080601174255.GA22244@uranus.ravnborg.org>
References: <1212217507-32126-1-git-send-email-clifford@clifford.at> <20080531083034.GA2569@uranus.ravnborg.org> <20080601163439.GI1369@clifford.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080601163439.GI1369@clifford.at>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 06:34:39PM +0200, Clifford Wolf wrote:
> Hi,
> 
> On Sat, May 31, 2008 at 10:30:34AM +0200, Sam Ravnborg wrote:
> > On Sat, May 31, 2008 at 09:05:07AM +0200, Clifford Wolf wrote:
> > > The new 'make no2modconfig' make target creates a new kernel
> > > config based on the current one, switching all tristate options
> > > from 'n' to 'm'.
> > 
> > In what situations do we need this functionality?
> 
> I'm using this patch (respectively its predecessors) since many years in
> ROCK Linux to auto-generate our general purpose kernel configurations, by
> copying the default kernel config, forcing some variables to yes or no and
> then setting all tristate options which are on 'n' to 'm' using this patch.
> 
> the only alternative would be to manually check the kernel configurtion for
> each new kernel and setting all new tristate options to 'm' by hand. what a
> waste of energy that would have been for the last couple of years..  ;-)

I have a set of patched in works that will allow this in
a more general way.
It allows you to specify a base config when you do allmodconfig.
Syntax is:

   make K=rock-config allmodconfig

This will result in exactly what you want.

I will try to find time during next week to polish them and submit them
for 2nd review.

	Sam
