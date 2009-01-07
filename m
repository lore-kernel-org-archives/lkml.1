Return-Path: <linux-kernel-owner+w=401wt.eu-S1762881AbZAGWil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762881AbZAGWil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:38:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932630AbZAGWeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:34:17 -0500
Received: from mail.gmx.net ([213.165.64.20]:37033 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932620AbZAGWeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:34:16 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX18ShuMCyMYSwoqepNqXmQYV+GWeJfLxggh6jtamKG
	u25XJjbp8oeXdc
Date: Wed, 7 Jan 2009 23:34:12 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: [BUG] NULL pointer deref with rcutorture
Message-ID: <20090107223412.GB32513@alice>
References: <20090105201631.GO6959@linux.vnet.ibm.com> <20090105203153.GC11244@alice> <20090105221836.GT6959@linux.vnet.ibm.com> <20090106002912.GA21071@linux.vnet.ibm.com> <20090106021506.GA23052@linux.vnet.ibm.com> <20090106074707.GA5975@alice> <20090106124809.GC7655@linux.vnet.ibm.com> <20090107194635.GA17174@linux.vnet.ibm.com> <20090107201904.GA32513@alice> <20090107220646.GH6900@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090107220646.GH6900@linux.vnet.ibm.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.28-rc9-00057-g8960223 (x86_64)
X-Uptime: 23:33:52 up 1 day, 15:00,  6 users,  load average: 0.09, 0.12,
	0.19
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Wed, Jan 07, 2009 at 09:19:04PM +0100, Eric Sesterhenn wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Tue, Jan 06, 2009 at 04:48:09AM -0800, Paul E. McKenney wrote:
> > > > On Tue, Jan 06, 2009 at 08:47:07AM +0100, Eric Sesterhenn wrote:
> > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > > On Mon, Jan 05, 2009 at 04:29:12PM -0800, Paul E. McKenney wrote:
> > > > > > > On Mon, Jan 05, 2009 at 02:18:36PM -0800, Paul E. McKenney wrote:
> > > > > > > I will see what I can find from this.
> > > > > > 
> > > > > > Hello, Eric,
> > > > > > 
> > > > > > Just for grins, I built the 2.6.28 kernel/rcutorture.c on b58602a.  It
> > > > > > insmoded and rmmoded without errors.
> > > > > > 
> > > > > > Could you please try this on your setup?  I have attached this file in
> > > > > > case that helps.
> > > > > 
> > > > > works like a charm
> > > > 
> > > > Well, that certainly tells me where the bug lies.  ;-)
> > > > 
> > > > Thank you for all your hard work on this, I should have a patch soon.
> > > 
> > > And here it is, against the original version of rcutorture.c (revert
> > > all of my previous patches against rcutorture.c).  I am also attaching
> > > the resulting rcutorture.c, if that makes things more convenient for you.
> > > 
> > > Could you please fire this up and see if it fixes the rmmod-time bug
> > > that you located?
> > 
> > it does fix the bug, thanks for your work
> 
> Thank you very much for finding this one, bearing with me during the
> debug process, and testing it!  I will post the patch with credit to you.
> 
> Does this fix all of the problems that you observed, or is there still
> some breakage?

It fixes everything i saw. Thanks.

Eric
