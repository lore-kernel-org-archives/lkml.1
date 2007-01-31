Return-Path: <linux-kernel-owner+w=401wt.eu-S932973AbXAaKmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbXAaKmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:42:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932963AbXAaKl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:41:59 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55620 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932969AbXAaKl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:41:58 -0500
Message-ID: <45C07275.9010501@garzik.org>
Date: Wed, 31 Jan 2007 05:41:57 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Divy Le Ray <None@chelsio.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 8/10] cxgb3 - Unmap offload packets when they are freed.
References: <20070131034424.8651.4713.stgit@localhost.localdomain>
In-Reply-To: <20070131034424.8651.4713.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
> From: Divy Le Ray <divy@chelsio.com>
> 
> Offload packets may be DMAed long after their SGE Tx descriptors are done
> so they must remain mapped until they are freed rather than until their
> descriptors are freed.  Unmap such packets through an skb destructor.
> 
> Signed-off-by: Divy Le Ray <divy@chelsio.com>

this is questionable and sounds like you are working around a bug.  I 
can't think of another driver that uses skb destructors, and I could 
have sworn that skb destructors were not for drivers to use anyway

	Jeff


