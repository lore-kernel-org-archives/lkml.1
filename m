Return-Path: <linux-kernel-owner+w=401wt.eu-S1751484AbZKHEJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbZKHEJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 23:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbZKHEJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 23:09:57 -0500
Received: from ozlabs.org ([203.10.76.45]:35166 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbZKHEJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 23:09:56 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCHv7 3/3] vhost_net: a kernel-level virtio server
Date: Sun, 8 Nov 2009 14:39:59 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com, s.hetze@linux-ag.com
References: <cover.1257267892.git.mst@redhat.com> <200911061531.20299.rusty@rustcorp.com.au> <20091106163007.GC6746@linux.vnet.ibm.com>
In-Reply-To: <20091106163007.GC6746@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911081439.59770.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Nov 2009 03:00:07 am Paul E. McKenney wrote:
> On Fri, Nov 06, 2009 at 03:31:20PM +1030, Rusty Russell wrote:
> > But it's still nasty to use half an API.  If it were a few places I would
> > have open-coded it with a comment, or wrapped it.  As it is, I don't think
> > that would be a win.
> 
> So would it help to have a rcu_read_lock_workqueue() and
> rcu_read_unlock_workqueue() that checked nesting and whether they were
> actually running in the context of a workqueue item?  Or did you have
> something else in mind?  Or am I misjudging the level of sarcasm in
> your reply?  ;-)

You read correctly.  If we get a second user, creating an API makes sense.

Thanks,
Rusty.
