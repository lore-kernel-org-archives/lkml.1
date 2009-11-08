Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbZKHTg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbZKHTg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 14:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbZKHTg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 14:36:27 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57744 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbZKHTgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 14:36:25 -0500
Date: Sun, 8 Nov 2009 11:36:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com, s.hetze@linux-ag.com
Subject: Re: [PATCHv7 3/3] vhost_net: a kernel-level virtio server
Message-ID: <20091108193633.GL8424@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1257267892.git.mst@redhat.com> <200911061531.20299.rusty@rustcorp.com.au> <20091106163007.GC6746@linux.vnet.ibm.com> <200911081439.59770.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911081439.59770.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 02:39:59PM +1030, Rusty Russell wrote:
> On Sat, 7 Nov 2009 03:00:07 am Paul E. McKenney wrote:
> > On Fri, Nov 06, 2009 at 03:31:20PM +1030, Rusty Russell wrote:
> > > But it's still nasty to use half an API.  If it were a few places I would
> > > have open-coded it with a comment, or wrapped it.  As it is, I don't think
> > > that would be a win.
> > 
> > So would it help to have a rcu_read_lock_workqueue() and
> > rcu_read_unlock_workqueue() that checked nesting and whether they were
> > actually running in the context of a workqueue item?  Or did you have
> > something else in mind?  Or am I misjudging the level of sarcasm in
> > your reply?  ;-)
> 
> You read correctly.  If we get a second user, creating an API makes sense.

Makes sense to me as well.  Which does provide some time to come up with
a primitive designed to answer the question "Am I currently executing in
the context of a workqueue item?".  ;-)

							Thanx, Paul
