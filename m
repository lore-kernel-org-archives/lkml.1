Return-Path: <linux-kernel-owner+w=401wt.eu-S932368Ab0ANUiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368Ab0ANUiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932306Ab0ANUiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:38:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56401 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938Ab0ANUiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:38:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [Bug #15041] Pagemap endless read loop with LTP
Date: Thu, 14 Jan 2010 21:38:51 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Andi Kleen <andi@firstfloor.org>,
       =?utf-8?q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <20100113235010.GF24818@basil.fritz.box> <1263428136.29868.5058.camel@calx>
In-Reply-To: <1263428136.29868.5058.camel@calx>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001142138.51506.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 January 2010, Matt Mackall wrote:
> On Thu, 2010-01-14 at 00:50 +0100, Andi Kleen wrote:
> > On Wed, Jan 13, 2010 at 10:57:34PM +0100, Rafael J. Wysocki wrote:
> > > On Wednesday 13 January 2010, Américo Wang wrote:
> > > > On Mon, Jan 11, 2010 at 6:32 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > > This message has been generated automatically as a part of a report
> > > > > of recent regressions.
> > > > >
> > > > > The following bug entry is on the current list of known regressions
> > > > > from 2.6.32.  Please verify if it still should be listed and let me know
> > > > > (either way).
> > > > >
> > > > >
> > > > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15041
> > > > > Subject         : Pagemap endless read loop with LTP
> > > > > Submitter       : Andi Kleen <andi@firstfloor.org>
> > > > > Date            : 2010-01-10 2:09 (1 days old)
> > > > > References      : http://marc.info/?l=linux-kernel&m=126308941423848&w=4
> > > > >
> > > > 
> > > > According to Andi's later reply, it shoud not be an endless loop,
> > > > it just takes a rather long time.
> > > 
> > > Andi?
> > 
> > It'll try to read 47 bits worth of 0s on 64bit x86-64. 
> > 
> > I haven't tried to wait until that finishes, but I estimate a few months of 
> > CPU time at least.
> > 
> > The interface is just misdesigned, but I guess we cannot do
> > anything about that for now.
> 
> It's perfectly sensible. What's not sensible is reading the entirety of
> everything you find in /proc, something that just about every Linux
> admin figures out moments after running their first recursive grep.
> 
> >  LTP will just need to do a workaround.
> 
> Or they could actually, you know, add a test of pagemap. Not much chance
> of that, though - CVS reports it took them until 2005 to figure out that
> skipping /proc/kcore was a good idea.

Closing as "documented".

Rafael
