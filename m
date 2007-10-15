Return-Path: <linux-kernel-owner+w=401wt.eu-S934552AbXJOUOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934552AbXJOUOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765181AbXJOUN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:13:58 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59943 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933319AbXJOUN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:13:56 -0400
Message-ID: <4713C9FA.2080306@pobox.com>
Date: Mon, 15 Oct 2007 16:13:46 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] xen-netfront: use net_device's stats structure
References: <470C2737.60403@goop.org> <4713AFC3.8000403@pobox.com> <4713C6B9.1010402@goop.org>
In-Reply-To: <4713C6B9.1010402@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Jeff Garzik wrote:
>> ACK patches 1-3, but they still do not apply.
>>
>> Since net-2.6.24 has gone upstream, you may send diffs against
>> torvalds/linux-2.6.git if you like -- there are no outstanding
>> dependencies at this time.
> 
> Yes, there was a larger patch which globally rolled all the private
> stats structures into the netdev one, so the xen-specfic one was
> redundant, and someone else submitted the deadcode removal one, so the
> only outstanding patch is this one:
> 
> Subject: xen-netfront: rearrange netfront structure to separate tx and rx
> 
> Keep tx and rx elements separate on different cachelines to prevent
> bouncing.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Acked-by: Jeff Garzik <jgarzik@pobox.com>
> Cc: Stephen Hemminger <shemminger@linux-foundation.org>
> Cc: Christoph Hellwig <hch@infradead.org>

applied


