Return-Path: <linux-kernel-owner+w=401wt.eu-S1759453AbZABXMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbZABXMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 18:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZABXMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 18:12:46 -0500
Received: from mail.gmx.net ([213.165.64.20]:40915 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751995AbZABXMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 18:12:45 -0500
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX1++loJ90bW+2qovG7wrr5h3bClFfHVXuTHr8J0fsK
	nrUZJAEL1LGmMp
Date: Sat, 3 Jan 2009 00:12:39 +0100
From: Eric Sesterhenn <snakebyte@gmx.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: [BUG] NULL pointer deref with rcutorture
Message-ID: <20090102231239.GA19778@alice>
References: <20090102111819.GC6088@alice> <20090102175853.GC6842@linux.vnet.ibm.com> <20090102185303.GC5743@linux.vnet.ibm.com> <20090102195326.GF6842@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090102195326.GF6842@linux.vnet.ibm.com>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.28-rc9-00057-g8960223 (x86_64)
X-Uptime: 00:09:05 up 13:21,  8 users,  load average: 0.18, 0.41, 0.42
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Sat, Jan 03, 2009 at 12:23:03AM +0530, Kamalesh Babulal wrote:
> > * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [2009-01-02 09:58:53]:
> > 
> > > On Fri, Jan 02, 2009 at 12:18:19PM +0100, Eric Sesterhenn wrote:
> > > > Hi,
> > > > 
> > > > modprobing rcutorture and removing it again gives me the following oops:
> > > 
> > > This looks similar to something that Kamalesh ran into a few weeks ago.
> > > 
> > > Kamalesh, did the fixes for that make it to 2.6.28?
> > > 
> > > 							Thanx, Paul
> > > 
> > 
> > Hi Paul,
> > 
> > 	The fix was available in linux-next from Dec 23 2008 (commit 392ddc32982a5c661dd90dd49a3cb37f1c68b782
> > 'bio: add support for inlining a number of bio_vecs inside the bio') and it has be pushed for merger in 2.6.29.
> 
> Thank you, Kamalesh!
> 
> Eric, could you please try applying the above commit and see if the
> problem reproduces?

I tried to apply the patch from
http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff_plain;h=392ddc32982a5c661dd90dd49a3cb37f1c68b782;hp=bb799ca0202a360fa74d5f17039b9100caebdde7
but get a message that it is already applied. Seems i already got that
one.

Greetings, Eric
