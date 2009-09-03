Return-Path: <linux-kernel-owner+w=401wt.eu-S1755450AbZICNzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbZICNzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbZICNzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:55:07 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:48030 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755316AbZICNzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:55:05 -0400
Date: Thu, 3 Sep 2009 12:50:53 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] slub: fix slab_pad_check() and SLAB_DESTROY_BY_RCU
In-Reply-To: <84144f020909030051u6cf6ae01he25c268f718ff3af@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0909031246010.27903@V090114053VZO-1>
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>  <c4e36d110908140233v59421ba6y82192b858210370d@mail.gmail.com>  <4A87CE60.4020506@gmail.com> <4A896324.3040104@trash.net>  <c4e36d110909021445l5f44183es9e338437dfbbd195@mail.gmail.com>
  <4A9EEF07.5070800@gmail.com>  <c4e36d110909021531v324a9ce2x3ff2c93b7c5a57de@mail.gmail.com>  <4A9F1620.2080105@gmail.com>  <84144f020909022331x2b275aa5n428f88670e0ae8bc@mail.gmail.com>  <4A9F7283.1090306@gmail.com>
 <84144f020909030051u6cf6ae01he25c268f718ff3af@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Sep 2009, Pekka Enberg wrote:

> Oh, sure, the fix looks sane to me. It's just that I am a complete
> coward when it comes to merging RCU related patches so I always try to
> fish an Acked-by from Paul or Christoph ;).

I am fine with acking the poison piece.

I did not ack the patch that added rcu to kmem_cache_destroy() and I
likely wont ack that piece either.



