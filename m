Return-Path: <linux-kernel-owner+w=401wt.eu-S1759887AbYBPGUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759887AbYBPGUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 01:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbYBPGUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 01:20:01 -0500
Received: from mail.gmx.net ([213.165.64.20]:54281 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752018AbYBPGUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 01:20:00 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19NFtlekJdNpjwPl5JUgbItYXGPVCxSk1OJmEkL2s
	0M4OcNx06uHnO7
Subject: Re: [2.6.25-rc1] jerky mouse cursor and randoooom key repeats
From: Mike Galbraith <efault@gmx.de>
To: Gabriel C <crazy@frugalware.org>
Cc: Pavel Machek <pavel@ucw.cz>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <47B63B23.2040701@frugalware.org>
References: <200802111623.38478.elendil@planet.nl>
	 <200802130941.47163.elendil@planet.nl> <20080215235842.GA5190@ucw.cz>
	 <47B63B23.2040701@frugalware.org>
Content-Type: text/plain
Date: Sat, 16 Feb 2008 07:19:56 +0100
Message-Id: <1203142796.17270.11.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-16 at 02:23 +0100, Gabriel C wrote:
> Pavel Machek wrote:
> > Hi!
> 
> Hi ,
> 
> >> I'd not really done any real workkkk under 2.6.25 yet, but now while running 
> >> a kernel compile with -j4 (single processor, dual core Pentium D), I see 
> >> this behavior. The mouse cursor moves a bit jerky and I sometimes get key 
> >> presses repeated.
> > 
> > I see this one, too... x60, too...
> > 
> 
> I have that problem on my Dell Precision WorkStation , as soon I stress the box
> a bit keyboard is going mad.

Sounds like you may have CONFIG_GROUP_SCHED set?  Bisection fingered
6b2d7700266b9402e12824e11e0099ae6a4a6a79 as the source here.

	-Mike

