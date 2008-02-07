Return-Path: <linux-kernel-owner+w=401wt.eu-S1761145AbYBGDEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761145AbYBGDEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 22:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758403AbYBGDEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 22:04:13 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:23426 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557AbYBGDEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 22:04:12 -0500
X-IMAP-Sender: amg
Date: Wed, 6 Feb 2008 22:04:10 -0500
From: Amy Griffis <amy.griffis@hp.com>
To: Clem Taylor <clem.taylor@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: inotify_add_watch() returning ENOSPC in 2.6.24 [watch
	descriptor leak?]
Message-ID: <20080207030409.GA14880@fc.hp.com>
References: <ecb4efd10802051749n6a626e84k3ac8210aa2b5a446@mail.gmail.com> <20080206015103.9a0f4069.akpm@linux-foundation.org> <ecb4efd10802061140g929e699y8d79f1317c30478d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecb4efd10802061140g929e699y8d79f1317c30478d@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clem Taylor wrote:  [Wed Feb 06 2008, 02:40:58PM EST]
> > Good bug report, thanks.  That code was significantly altered in June 2006
> > and perhaps something broke.
> 
> I also tested on a 2.6.20 x86 desktop machine. It took ~8k iterations
> to fail, which matched max_user_watches. Once the program fails, it
> will fail right away if it is re-run.
> 
> > It's a bit hard to find people who work on inotify, I'm afraid.  If you had
> > the time to come up with a script or program which demonstrates the bug,
> > that would be super-helpful?
> 
> Attached is a simple example that shows off the problem. On a system
> with a problem, it will only run for about
> fs.inotify.max_user_watches iterations. If everything is working, it
> should run forever.

I'll take a look at this. Thanks for providing a reproducer.

Amy
