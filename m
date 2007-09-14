Return-Path: <linux-kernel-owner+w=401wt.eu-S1762299AbXINM4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762299AbXINM4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 08:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbXINMz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 08:55:56 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:57595 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbXINMzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 08:55:55 -0400
Date: Fri, 14 Sep 2007 16:55:38 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Steve Wise <swise@opengridcomputing.com>
Cc: Jeff Garzik <jeff@garzik.org>, Roland Dreier <rdreier@cisco.com>,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [ofa-general] InfiniBand/RDMA merge plans for 2.6.24
Message-ID: <20070914125536.GF18517@2ka.mipt.ru>
References: <adahclymos8.fsf@cisco.com> <46E97BB0.9030106@opengridcomputing.com> <46E987E0.2010605@garzik.org> <46E98889.1080706@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E98889.1080706@opengridcomputing.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 01:59:21PM -0500, Steve Wise (swise@opengridcomputing.com) wrote:
> >Well, if it involves /sharing/ port space with the native stack, i.e. 
> >where port 1234 is IB but 1235 is Linux, pretty much all the networking 
> >devs have NAK'd that approach AFAICS.
> 
> Jeff, I posted a fix that doesn't do this.  No port sharing.  The iwarp 
> device will use its own ip address and subnet to avoid collisions.  You 
> should review the patch when I post v2.

Could you please resend it, since I missed it in netdev@.

-- 
	Evgeniy Polyakov
