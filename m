Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980Ab0AEVxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab0AEVxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627Ab0AEVxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:53:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab0AEVxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:53:53 -0500
Date: Tue, 5 Jan 2010 23:50:51 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: eric.dumazet@gmail.com, nhorman@tuxdriver.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: packet: option to only pass skb protocol
Message-ID: <20100105215051.GD30921@redhat.com>
References: <20100105185732.GA30346@redhat.com> <4B439299.1090205@gmail.com> <20100105205040.GA30921@redhat.com> <20100105.134038.21223965.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105.134038.21223965.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 01:40:38PM -0800, David Miller wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> Date: Tue, 5 Jan 2010 22:50:40 +0200
> 
> > binding socket to device might be done by a separate process
> > from the one doing sendmsg, and IMO the device socket is bound
> > to might change at any time.
> > 
> > So the sending process would need to get socket name before
> > each sendmsg.
> > 
> > Makes sense?
> 
> Not really, when it's at the expense of everyone else.
> 
> If you can pass the FD around, you can pass around auxiliary
> information as well.
> 
> Make sense? :-)

At some level, of course I can. But I would have to do this
communication each time socket is bound to another device, as opposed to
passing the fd once.  At least for me, option to autodetect protocol
would work even better though - it's  what I do in the application
anyway.

-- 
MST
