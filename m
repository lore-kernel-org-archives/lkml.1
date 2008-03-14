Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbYCNOQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbYCNOQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757185AbYCNOQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:16:20 -0400
Received: from khc.piap.pl ([195.187.100.11]:46206 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbYCNOQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:16:19 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Re: WAN: new PPP code for generic HDLC
References: <m3prtzsszg.fsf@maximus.localdomain>
	<m3lk4nsskh.fsf@maximus.localdomain>
	<Pine.LNX.4.64.0803122032410.14822@fbirervta.pbzchgretzou.qr>
	<m33aqvsnyg.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Fri, 14 Mar 2008 15:16:16 +0100
In-Reply-To: <m33aqvsnyg.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Wed\, 12 Mar 2008 21\:10\:31 +0100")
Message-ID: <m31w6d4ci7.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa <khc@pm.waw.pl> writes:

> It can't if the hdlc header is 32-bit aligned... however, I can now
> see the above is buggy, skb->data doesn't point to the protocol
> field. Unused code paths :-(

Actually I was wrong, the code is correct and skb->data points to the
proto ID.

PATCH v2 is on the way.
-- 
Krzysztof Halasa
