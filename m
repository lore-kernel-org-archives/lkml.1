Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbYHJTp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbYHJTp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 15:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYHJTpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 15:45:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50635 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbYHJTpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 15:45:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: resume from s2ram regression (bisected to ftrace...)
Date: Sun, 10 Aug 2008 21:48:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-pm@lists.linux-foundation.org
References: <20080810170801.GA5739@joi> <200808101940.13753.rjw@sisk.pl> <20080810192444.GA5296@joi>
In-Reply-To: <20080810192444.GA5296@joi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808102148.03046.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 10 of August 2008, Marcin Slusarz wrote:
> On Sun, Aug 10, 2008 at 07:40:12PM +0200, Rafael J. Wysocki wrote:
> > On Sunday, 10 of August 2008, Marcin Slusarz wrote:
> > > Hi
> > > 
> > > Few days ago I discovered that resume from suspend to ram does not work anymore
> > > on my 2.6.27-rc2 (actually 796aadeb1b2db9b5d463946766c5bbfd7717158c) gentoo box.
> > > My computer just boots on resume. Today I had enough time to bisect it and found
> > > (after 1 panic and 1 build breakage) out "the reason":
> > > 
> > > $ git bisect good
> > > d05cdb25d80f06f77aa6bddb53cd1390d4d91a0b is first bad commit
> > > commit d05cdb25d80f06f77aa6bddb53cd1390d4d91a0b
> > > Author: Steven Rostedt <rostedt@goodmis.org>
> > > Date:   Mon May 12 21:20:54 2008 +0200
> > > 
> > >     ftrace: fix dynamic ftrace selftest
> > 
> > Does it still happen if:
> > - CONFIG_FTRACE is unset
> 
> no
> 
> > - CONFIG_FTRACE is set, but CONFIG_FTRACE_STARTUP_TEST is unset?
> 
> yes

Thanks for testing.

Well, ftrace is a new feature in 2.6.27, IIRC, so this is not a regression in
the strict sense.

Still, of couse, there is a bug in ftrace that needs to be fixed.  Steven?
