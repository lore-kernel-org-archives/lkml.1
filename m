Return-Path: <linux-kernel-owner+w=401wt.eu-S1751176AbZKFFBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbZKFFBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 00:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbZKFFBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 00:01:18 -0500
Received: from ozlabs.org ([203.10.76.45]:60127 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbZKFFBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 00:01:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCHv7 3/3] vhost_net: a kernel-level virtio server
Date: Fri, 6 Nov 2009 15:31:20 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu, linux-mm@kvack.org,
       akpm@linux-foundation.org, hpa@zytor.com, s.hetze@linux-ag.com
References: <cover.1257267892.git.mst@redhat.com> <20091104115729.GD8398@redhat.com> <20091104172542.GC6736@linux.vnet.ibm.com>
In-Reply-To: <20091104172542.GC6736@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911061531.20299.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009 03:55:42 am Paul E. McKenney wrote:
> On Wed, Nov 04, 2009 at 01:57:29PM +0200, Michael S. Tsirkin wrote:
> > Can you ack this usage please?
> 
> I thought I had done so in my paragraph above, but if you would like
> something a bit more formal...

<snip verbose super-ack with qualifications>

That's great guys.  And yes, this is a kind of read-copy-update.  And no,
there's nothing wrong with it.

But it's still nasty to use half an API.  If it were a few places I would
have open-coded it with a comment, or wrapped it.  As it is, I don't think
that would be a win.

Cheers,
Rusty.
