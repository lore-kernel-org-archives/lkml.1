Return-Path: <linux-kernel-owner+w=401wt.eu-S1423267AbXBHTh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423267AbXBHTh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423280AbXBHTh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:37:26 -0500
Received: from tim.rpsys.net ([194.106.48.114]:38987 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423278AbXBHThZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:37:25 -0500
Subject: Re: Git backlight subsystem tree
From: Richard Purdie <rpurdie@rpsys.net>
To: James Simmons <jsimmons@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Marcin Juszkiewicz <openembedded@hrw.one.pl>, Greg KH <greg@kroah.com>
In-Reply-To: <Pine.LNX.4.64.0702081830520.7686@pentafluge.infradead.org>
References: <1170901826.5859.2.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702081520110.824@pentafluge.infradead.org>
	 <1170957595.5849.11.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702081830520.7686@pentafluge.infradead.org>
Content-Type: text/plain
Date: Thu, 08 Feb 2007 19:37:06 +0000
Message-Id: <1170963426.5849.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-08 at 18:32 +0000, James Simmons wrote:
> On Thu, 8 Feb 2007, Richard Purdie wrote:
> 
> > On Thu, 2007-02-08 at 15:28 +0000, James Simmons wrote:
> > > I have some patches that move the backlight away from using the class 
> > > stuff. The only problem is the patch requires all backlight devices 
> > > to be linked to a real struct device. Right now the acpi backligths are 
> > > not.
> > 
> > Why would you want to do that?
[...]
>
> I CC Greg to explain. The backlight class didn't go away. The way it is 
> handled is different.

>From the changelog and a quick skim though the patch it looked like you
were just removing the class functionality and using the struct device
directly but I see what you're trying to do now.

I'm not sure I agree with it though as it results in two devices for
each backlight user as almost all users have an existing struct device.
The current approach allows you to attach the class to an existing
device and also means you can attach multiple classes to a given device
which gives more flexibility.

So the above question stills stands, why would you want to do this
(apart from removing some code)?

Richard

