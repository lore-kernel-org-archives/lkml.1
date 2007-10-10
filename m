Return-Path: <linux-kernel-owner+w=401wt.eu-S1756661AbXJJBEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661AbXJJBEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 21:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbXJJBEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 21:04:15 -0400
Received: from gw.goop.org ([64.81.55.164]:54373 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbXJJBEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 21:04:14 -0400
Message-ID: <470C24E2.7080009@goop.org>
Date: Tue, 09 Oct 2007 18:03:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: NetDev <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xen-netfront: rearrange netfront_info structure to separate
 tx and rx
References: <470BCC1D.4080007@goop.org> <470C20E9.9050405@garzik.org>
In-Reply-To: <470C20E9.9050405@garzik.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Jeremy Fitzhardinge wrote:
>> Keep tx and rx elements separate on different cachelines to prevent
>> bouncing.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
>> Cc: Stephen Hemminger <shemminger@linux-foundation.org>
>> Cc: Christoph Hellwig <hch@infradead.org>
>>
>> ---
>>  drivers/net/xen-netfront.c |   37 ++++++++++++++++++-------------------
>>  1 file changed, 18 insertions(+), 19 deletions(-)
>
> ACK but does not apply to jgarzik/netdev-2.6.git#upstream nor
> davem/net-2.6.24.git 

Oh, OK, I'll have a look.  I wasn't aware of any other changes in
xen-netfront.  Or rather, there are a couple of other changes which I
think you already have: one to use the common netdev stats structure,
and another to remove a chunk of dead code.

    J
