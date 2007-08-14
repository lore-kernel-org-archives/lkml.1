Return-Path: <linux-kernel-owner+w=401wt.eu-S933602AbXHNSaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602AbXHNSaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbXHNS3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:29:55 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:45737 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755567AbXHNS3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:29:54 -0400
Message-ID: <46C1F3A7.3090007@gmail.com>
Date: Tue, 14 Aug 2007 20:25:43 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Joe Perches <joe@perches.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [443/2many] MAINTAINERS - HIBERNATION (aka Software Suspend,
 aka swsusp):
References: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com>  <200708132338.25925.rjw@sisk.pl> <20070814070528.GA2903@elf.ucw.cz>  <200708141937.06676.rjw@sisk.pl> <1187114231.32555.105.camel@localhost> <alpine.LFD.0.999.0708141112110.30176@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708141112110.30176@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2007 08:15 PM, Linus Torvalds wrote:

> Quite frankly, I think the MAINTAINERS file gets a whole lot uglier this 
> way.
> 
> There's also a rather fundamental issue: this will likely make people 
> touch the MAINTAINERS file *more*, and from a maintenance standpoint, that 
> is exactly the wrong thing to have (one central file that everybody 
> touches). It just tends to generate unnecessary merge conflicts etc. 
> 
> (We used to have that issue with the central configuration file, for 
> example).
> 
> So the more I look at these things, the more convinced I am that this is 
> not the right thing to do. These things should *not* be in one huge file, 
> and I'd much much rather have the maintainership information be carried 
> along with the subsystem itself, or the files it contains.
> 
> In other words, it would be much better to just have per-file markers, 
> along with some per-subdirectory stuff or similar.

Joe just now convinced me that rather than the per-file markers, the marker 
is meta-information that could just be stored in GIT, with the MAINTAINERS 
file turning into something generated.

git info --maintainer and such (for many possible kinds of --flags) would 
throw out the information.

Rene.
