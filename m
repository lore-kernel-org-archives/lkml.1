Return-Path: <linux-kernel-owner+w=401wt.eu-S1752516AbZIHWm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbZIHWm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZIHWmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:42:25 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:58131 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751089AbZIHWmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:42:24 -0400
Date: Tue, 8 Sep 2009 18:41:14 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] slub: fix slab_pad_check()
In-Reply-To: <20090908222036.GM6753@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.1.10.0909081839090.7733@V090114053VZO-1>
References: <4A9FCDC6.3060003@gmail.com> <alpine.DEB.1.10.0909031335430.29881@V090114053VZO-1> <4A9FDA72.8060001@gmail.com> <alpine.DEB.1.10.0909031414310.29881@V090114053VZO-1> <4AA00400.1030005@gmail.com> <alpine.DEB.1.10.0909031731540.24199@V090114053VZO-1>
 <20090903231757.GP6761@linux.vnet.ibm.com> <alpine.DEB.1.10.0909041140040.9781@V090114053VZO-1> <20090904204335.GG6751@linux.vnet.ibm.com> <alpine.DEB.1.10.0909081555410.26382@V090114053VZO-1> <20090908222036.GM6753@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009, Paul E. McKenney wrote:

> Are you saying that people have already asked you for additional
> variants of SLAB_DESTROY_BY_RCU?  If so, please don't keep them a secret!
> Otherwise, experience indicates that it is best to wait for the new uses,
> because they usually aren't quite what one might expect.

No direct request but I have seen the network developers discover these
features and their caching benefits over the last year. It is likely that
they will try to push it into more components of the net subsystem.
