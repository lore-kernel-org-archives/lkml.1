Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbZKLXA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbZKLXA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbZKLXAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:00:51 -0500
Received: from mail.vyatta.com ([76.74.103.46]:49844 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbZKLXAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:00:51 -0500
Date: Thu, 12 Nov 2009 15:00:29 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: sclark46@earthlink.net
Cc: William Allen Simpson <william.allen.simpson@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2] Documentation: rw_lock lessons learned
Message-ID: <20091112150029.1a26c641@nehalam>
In-Reply-To: <4AFC5E3F.7070609@earthlink.net>
References: <4AF9C540.5090403@gmail.com>
	<20091110180646.2e5859a8@nehalam>
	<4AFAEF78.4080807@gmail.com>
	<20091111093724.4f40a48d@nehalam>
	<4AFBEC44.9030409@gmail.com>
	<4AFC5E3F.7070609@earthlink.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Nov 2009 14:13:03 -0500
Stephen Clark <sclark46@earthlink.net> wrote:

> William Allen Simpson wrote:
> > In recent weeks, two different network projects erroneously
> > strayed down the rw_lock path.  Update the Documentation
> > based upon comments by Eric Dumazet and Paul E. McKenney in
> > those threads.
> > 
> > Merged with editorial changes by Stephen Hemminger.
> > 
> > Signed-off-by: William.Allen.Simpson@gmail.com
> > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  Documentation/spinlocks.txt |  186 
> > ++++++++++++++++++++-----------------------
> >  1 files changed, 86 insertions(+), 100 deletions(-)
> > 
> 
> How up to date is this doc?
> 
> http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/index.html
> 

Out of date.
1. Missing mutex's which have largely replaced semaphores.

2. Missing change to lock initialization in later kernels.

3. Missing description of lock dependency checker which should be in same guide.
