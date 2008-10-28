Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbYJ1XWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbYJ1XWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 19:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYJ1XWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 19:22:04 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44547 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbYJ1XWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 19:22:02 -0400
To: rjw@sisk.pl
CC: miklos@szeredi.hu, ncunningham@crca.org.au,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <200810282321.59041.rjw@sisk.pl>
Subject: Re: [linux-pm] Freezer: Don't count threads waiting for frozen filesystems.
References: <1224886068.6478.21.camel@nigel-laptop> <200810282300.31164.rjw@sisk.pl> <E1Kuwe3-0006Gc-LF@pomaz-ex.szeredi.hu> <200810282321.59041.rjw@sisk.pl>
Message-Id: <E1Kuxsg-0006PR-Tr@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 29 Oct 2008 00:21:46 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2008, Rafael J. Wysocki wrote:
> On Tuesday, 28 of October 2008, Miklos Szeredi wrote:
> > I would prefer a freezer-less solution.  Suspend to ram doesn't need
> > the freezer,
> 
> Well, yes it does.  And it will in forseeable future, AFAICS.

Umm, OK.  Last I remember everybody agreed that there's absolutely no
reason why processes need to be frozen, and the only important thing
is that drivers are not twiddling the hardware during suspend, and
this can usually easily be solved on the subsystem level.

> > I don't think adding hacks to the VFS to work around the issues with
> > the freezer is the right way to solve this.  But this is just my
> > personal opinion, the VFS maintainers may think otherwise.
> 
> Well, my personal opinion is that we need filesystems to support suspend,
> this way or another and the sooner it happens, the better.  Still, I'm rather
> not going to make that happen myself. :-)
> 
> Apparently, Nigel is willing to work in this direction and we can use this as
> an opportunity to learn what exactly is necessary for this purpose and _then_
> decide if this is reasonable or not instead of dismissing it upfront.

I haven't dismissed it, just voiced my opinion that I think it's the
wrong direction.

Miklos
