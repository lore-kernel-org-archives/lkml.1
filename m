Return-Path: <linux-kernel-owner+w=401wt.eu-S1755078AbXJJAqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbXJJAqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 20:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbXJJAqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 20:46:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44615 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbXJJAqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 20:46:38 -0400
Message-ID: <470C20E9.9050405@garzik.org>
Date: Tue, 09 Oct 2007 20:46:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: NetDev <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>,
       Stephen Hemminger <shemminge@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xen-netfront: rearrange netfront_info structure to separate
 tx and rx
References: <470BCC1D.4080007@goop.org>
In-Reply-To: <470BCC1D.4080007@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Keep tx and rx elements separate on different cachelines to prevent
> bouncing.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Stephen Hemminger <shemminger@linux-foundation.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> 
> ---
>  drivers/net/xen-netfront.c |   37 ++++++++++++++++++-------------------
>  1 file changed, 18 insertions(+), 19 deletions(-)

ACK but does not apply to jgarzik/netdev-2.6.git#upstream nor 
davem/net-2.6.24.git


