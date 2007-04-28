Return-Path: <linux-kernel-owner+w=401wt.eu-S1030810AbXD1VOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030810AbXD1VOo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030819AbXD1VOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:14:44 -0400
Received: from www.osadl.org ([213.239.205.134]:46092 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030810AbXD1VOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:14:43 -0400
From: =?utf-8?q?Hans-J=C3=BCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: tglx@linutronix.de
Subject: Re: Flaws with "UIO: Add the User IO core code"
Date: Sat, 28 Apr 2007 23:14:15 +0200
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, torvalds@osdl.org,
       Benedikt Spranger <b.spranger@linutronix.de>
References: <20070427224957.GA17967@kroah.com> <200704282303.06727.hjk@linutronix.de> <1177794532.7646.313.camel@localhost.localdomain>
In-Reply-To: <1177794532.7646.313.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704282314.15274.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 28 April 2007 23:08 schrieb Thomas Gleixner:
> On Sat, 2007-04-28 at 23:03 +0200, Hans-Jürgen Koch wrote:
> > Am Samstag 28 April 2007 22:24 schrieb Alan Cox:
> > > > > AFAIK we don't currently have any platform that runs binaries with
> > > > > different sizes of "int" but this is a) an unsigned value anyway, and b)
> > > > > should be a fixed type (eg u32)
> > > > 
> > > > I reviewed the code once more and find it OK. There is only one legal
> > > > value for the parameter "count" of uio_read(), and that's sizeof(int).
> > > 
> > > If you are a box with multiple supported binary types how big is an
> > > "int". We use explicit sizes to ensure that uio_read() will work when/if
> > > we get platforms which support binaries with differing ideas of the size
> > > of "int". Thus it should use s32 or s64 or similar.
> > 
> > Here's a fix to that effect:
> 
> Can you please add a matching paragraph to the documentation ?
> 

Yes, I'll add a "How to write userspace code" section tomorrow. I'll send a 
patch as soon as it's ready.

Hans
 
