Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbXBHScH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbXBHScH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 13:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbXBHScG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 13:32:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35810 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbXBHScE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 13:32:04 -0500
Date: Thu, 8 Feb 2007 18:32:02 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Richard Purdie <rpurdie@rpsys.net>
cc: LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Marcin Juszkiewicz <openembedded@hrw.one.pl>, Greg KH <greg@kroah.com>
Subject: Re: Git backlight subsystem tree
In-Reply-To: <1170957595.5849.11.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0702081830520.7686@pentafluge.infradead.org>
References: <1170901826.5859.2.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0702081520110.824@pentafluge.infradead.org>
 <1170957595.5849.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Feb 2007, Richard Purdie wrote:

> On Thu, 2007-02-08 at 15:28 +0000, James Simmons wrote:
> > I have some patches that move the backlight away from using the class 
> > stuff. The only problem is the patch requires all backlight devices 
> > to be linked to a real struct device. Right now the acpi backligths are 
> > not.
> 
> Why would you want to do that?
> 
> The whole point of having this is so that backlights appear as a
> standard interface under /sys/class/backlight.
> 
> An example of why standardised interfaces are good would be someone
> writing an applet for a handheld to control the backlight brightness.
> With the class in place, the applet can easily work with any backlight.
> Without it, it has to be written for each backlight.
> 
> So this is a very strong NAK but I'm curious why you'd want to do it...

I CC Greg to explain. The backlight class didn't go away. The way it is 
handled is different.
