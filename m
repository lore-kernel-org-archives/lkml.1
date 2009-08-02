Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbZHBG3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbZHBG3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 02:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZHBG3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 02:29:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:35977 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751897AbZHBG3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 02:29:10 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18iIKwWo9Yi4Ka9S6YjxYP+UjyxdiOw8NSiuUN7fi
	jjxvx8RQkGFhEP
Subject: Re: rt2800usb: memory corruption?
From: Mike Galbraith <efault@gmx.de>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1249190209.7486.4.camel@marge.simson.net>
References: <1248945770.7910.24.camel@marge.simson.net>
	 <1248946195.8925.9.camel@johannes.local>
	 <1248947099.8396.6.camel@marge.simson.net>
	 <1248947740.8925.12.camel@johannes.local>
	 <1248948326.8823.4.camel@marge.simson.net>
	 <1248955916.7995.47.camel@marge.simson.net>
	 <1249104348.7146.60.camel@marge.simson.net>
	 <1249124154.8236.5.camel@marge.simson.net>  <1249172514.3043.7.camel@ct>
	 <1249190209.7486.4.camel@marge.simson.net>
Content-Type: text/plain
Date: Sun, 02 Aug 2009 08:29:06 +0200
Message-Id: <1249194546.7634.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-08-02 at 07:16 +0200, Mike Galbraith wrote:
> On Sat, 2009-08-01 at 20:21 -0400, Pavel Roskin wrote:
> > On Sat, 2009-08-01 at 12:55 +0200, Mike Galbraith wrote:
> > 
> > > Enabled slub/pagealloc debugging.  First down/rmmod said...
> > 
> > I suggest that you try kmemcheck.  It's very slow, but it finds memory
> > problems when they occur, not when it's too late.
> > 
> > You may want to disable kmemleak and framebuffer support and make sure
> > that X doesn't start, at it will be too slow.  Slub debugging might
> > conflict with kmemcheck, so it's better to disable it.
> 
> 
> I didn't even get as far as down/rmmod.  Kmemcheck fired as soon as the
> interface came up.

Corruption seems to be SMP only.  I cycled down/rmmod/modprobe a few
times with kmemcheck enabled (disables smp unfortunately), kmemcheck
didn't trigger, nor did box have a conniption.

	-Mike

