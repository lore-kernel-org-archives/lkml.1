Return-Path: <linux-kernel-owner+w=401wt.eu-S1759500AbXFMRJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759500AbXFMRJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 13:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757659AbXFMRJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 13:09:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37686 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756931AbXFMRJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 13:09:33 -0400
Message-ID: <467024C9.5010300@garzik.org>
Date: Wed, 13 Jun 2007 13:09:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Kyuma Ohta <whatisthis@jcom.home.ne.jp>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, leewkb@yahoo.com,
       netdev <netdev@vger.kernel.org>
Subject: Re: [patch 1/6] 8139too: force media setting cleanup
References: <200705232134.l4NLYcm2000578@shell0.pdx.osdl.net>	 <46560567.5060708@garzik.org> <1181739176.23954.23.camel@melchior>
In-Reply-To: <1181739176.23954.23.camel@melchior>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyuma Ohta wrote:
> Hi,
> I was testing 2.6.22-rc4 from yesterday,
> but communication speed  of 8139 side is very slower 
> than 2.6.21.* (less than 10kbytes/sec at  
> 100MBPS,FULL-DUPLEX).
> I was not test from 2.6.22-rc ,yesterday I started to test 2.6.22-rc.
> 
> So, I *must* set HALF-DUPLEX to 8139 side below:
> ethtool -s ethx speed 100 duplex half autoneg on 
> *x is number of 8139 assigned from udev.
> 
> So,Pls.apply this patch to upstream,and I test this too.

Your use of ethtool clearly demonstrates the lack of need for this patch.

	Jeff




