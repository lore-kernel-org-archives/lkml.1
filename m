Return-Path: <linux-kernel-owner+w=401wt.eu-S1032295AbXEHVRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032295AbXEHVRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:17:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032289AbXEHVRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:17:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37028 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032287AbXEHVRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:17:05 -0400
Message-ID: <4640E8C4.4000603@garzik.org>
Date: Tue, 08 May 2007 17:16:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Krzysztof Halasa <khc@pm.waw.pl>, David Rientjes <rientjes@google.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] doc: volatile considered evil
References: <516386418.20070501080839@gmail.com>	<20070430235642.e576e917.akpm@linux-foundation.org>	<20070508121404.17bd97a6.randy.dunlap@oracle.com>	<alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com> <m3k5vj2iha.fsf@maximus.localdomain> <4640E62D.8060704@goop.org>
In-Reply-To: <4640E62D.8060704@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> No, David means that "asm volatile (...)" is meaningful and OK to use.

In a driver?  Highly unlikey it is OK.  In a filesystem?  Even more 
unlikely it is OK to use.

The set of circumstances where 'volatile' is acceptable is very limited.

You will see it used properly in the definitions of writel(), for 
example.  But most drivers using 'volatile' are likely bugs.

	Jeff


