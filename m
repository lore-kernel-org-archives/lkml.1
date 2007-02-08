Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363AbXBHSAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbXBHSAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 13:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbXBHSAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 13:00:21 -0500
Received: from tim.rpsys.net ([194.106.48.114]:57966 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbXBHSAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 13:00:20 -0500
Subject: Re: Git backlight subsystem tree
From: Richard Purdie <rpurdie@rpsys.net>
To: James Simmons <jsimmons@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       Marcin Juszkiewicz <openembedded@hrw.one.pl>
In-Reply-To: <Pine.LNX.4.64.0702081520110.824@pentafluge.infradead.org>
References: <1170901826.5859.2.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702081520110.824@pentafluge.infradead.org>
Content-Type: text/plain
Date: Thu, 08 Feb 2007 17:59:55 +0000
Message-Id: <1170957595.5849.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-08 at 15:28 +0000, James Simmons wrote:
> I have some patches that move the backlight away from using the class 
> stuff. The only problem is the patch requires all backlight devices 
> to be linked to a real struct device. Right now the acpi backligths are 
> not.

Why would you want to do that?

The whole point of having this is so that backlights appear as a
standard interface under /sys/class/backlight.

An example of why standardised interfaces are good would be someone
writing an applet for a handheld to control the backlight brightness.
With the class in place, the applet can easily work with any backlight.
Without it, it has to be written for each backlight.

So this is a very strong NAK but I'm curious why you'd want to do it...

Richard


