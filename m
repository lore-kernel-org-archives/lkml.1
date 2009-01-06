Return-Path: <linux-kernel-owner+w=401wt.eu-S1752867AbZAFMsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbZAFMsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZAFMsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:48:11 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48286 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbZAFMsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:48:10 -0500
Date: Tue, 6 Jan 2009 04:48:09 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: [BUG] NULL pointer deref with rcutorture
Message-ID: <20090106124809.GC7655@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090105180037.GH6959@linux.vnet.ibm.com> <20090105185655.GA11244@alice> <20090105193602.GL6959@linux.vnet.ibm.com> <20090105200012.GB11244@alice> <20090105201631.GO6959@linux.vnet.ibm.com> <20090105203153.GC11244@alice> <20090105221836.GT6959@linux.vnet.ibm.com> <20090106002912.GA21071@linux.vnet.ibm.com> <20090106021506.GA23052@linux.vnet.ibm.com> <20090106074707.GA5975@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090106074707.GA5975@alice>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 08:47:07AM +0100, Eric Sesterhenn wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Mon, Jan 05, 2009 at 04:29:12PM -0800, Paul E. McKenney wrote:
> > > On Mon, Jan 05, 2009 at 02:18:36PM -0800, Paul E. McKenney wrote:
> > > I will see what I can find from this.
> > 
> > Hello, Eric,
> > 
> > Just for grins, I built the 2.6.28 kernel/rcutorture.c on b58602a.  It
> > insmoded and rmmoded without errors.
> > 
> > Could you please try this on your setup?  I have attached this file in
> > case that helps.
> 
> works like a charm

Well, that certainly tells me where the bug lies.  ;-)

Thank you for all your hard work on this, I should have a patch soon.

							Thanx, Paul
