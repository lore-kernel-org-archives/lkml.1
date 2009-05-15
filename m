Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbZEOVuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbZEOVuB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 17:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbZEOVtk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 17:49:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40242 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755475AbZEOVti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 17:49:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Regression since 2.6.30-rc1 - Page allocation failures
Date: Fri, 15 May 2009 23:49:47 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc5-rjw; KDE/4.2.2; x86_64; ; )
Cc: Johannes Berg <johannes@sipsolutions.net>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <49F8C03D.6040909@lwfinger.net> <1241040451.5067.0.camel@johannes.local> <49F8E145.1050708@lwfinger.net>
In-Reply-To: <49F8E145.1050708@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905152349.47940.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 April 2009, Larry Finger wrote:
> Johannes Berg wrote:
> > On Wed, 2009-04-29 at 23:09 +0200, Johannes Berg wrote:
> > 
> >> 	"%d, %d, need %d, %d", skb->data_len, skb->len, head_need, tail_need
> > 
> > actually, I think I want
> > 
> > 	skb_tail_pointer(skb) - skb->head
> > 
> > instead of skb->data_len.
> 
> I get the "failed to reallocate TX buffer" message. Not all are related to the
> page allocation failure. I am also getting "b43-phy0 debug: DMA RX:
> setup_rx_descbuffer() failed" messages.
> 
> So far, the numbers printed by the revised printk are:
> 
> kernel: phy0: failed to reallocate TX buffer 0, 404, need 0, 0
> kernel: protocol 0008 is buggy, dev eth1
> 
> kernel: phy0: failed to reallocate TX buffer 0, 1728, need 0, 18
> 
> Device eth1 is the b43 wireless device.

Can you please tell me what the status of this bug is?

Rafael
