Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbZINASD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbZINASD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 20:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbZINASC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 20:18:02 -0400
Received: from mail2.shareable.org ([80.68.89.115]:39138 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473AbZINASB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 20:18:01 -0400
Date: Mon, 14 Sep 2009 01:17:59 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Eric Paris <eparis@redhat.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, viro@zeniv.linux.org.uk, alan@linux.intel.com,
       hch@infradead.org
Subject: Re: [PATCH 1/8] networking/fanotify: declare fanotify socket numbers
Message-ID: <20090914001759.GB30621@shareable.org>
References: <20090911052558.32359.18075.stgit@paris.rdu.redhat.com> <20090911.114620.260824240.davem@davemloft.net> <1252697613.2305.38.camel@dhcp231-106.rdu.redhat.com> <20090911204602.GA19371@shareable.org> <1252703626.2305.50.camel@dhcp231-106.rdu.redhat.com> <20090911212731.GA19901@shareable.org> <1252705902.2305.83.camel@dhcp231-106.rdu.redhat.com> <20090912094110.GB24709@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090912094110.GB24709@ioremap.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Fri, Sep 11, 2009 at 05:51:42PM -0400, Eric Paris (eparis@redhat.com) wrote:
> > For some things yes, some things no.  I'd have to understand where loss
> > can happen to know if it's feasible.  If I know loss happens in the
> > sender context that's great.  If it's somewhere in the middle and the
> > sender doesn't immediately know it'll never be delivered, yes, I don't
> > think it can solve all my needs.  How many places can and skb get lost
> > between the sender and the receiver?
> 
> When queue is full or you do not have enough RAM. Both are reported at
> 'sending' time.

Can you ->poll() and wait reliably until the queue will accept an skb?
(A few spurious EAGAINs/ENOBUFs is ok, as long as it's not the norm).

-- Jamie
