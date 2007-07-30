Return-Path: <linux-kernel-owner+w=401wt.eu-S966443AbXG3Q0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966443AbXG3Q0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939294AbXG3QSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:18:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50511 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938482AbXG3QSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:18:11 -0400
Message-ID: <46AE0F36.8030605@garzik.org>
Date: Mon, 30 Jul 2007 12:17:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jan-Bernd Themann <ossthema@de.ibm.com>,
       David Miller <davem@davemloft.net>
CC: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Andrew Gallatin <gallatin@myri.com>
Subject: Re: [PATCH 0/4][RFC] lro: Generic Large Receive Offload for TCP traffic
References: <200707301724.33865.ossthema@de.ibm.com>
In-Reply-To: <200707301724.33865.ossthema@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seems pretty good to me, save for one minor detail:  patches #1/#2 
should be combined together for greater git-bisect happiness.  Ditto for 
patches #3/#4.  Largely harmless in this case, but keeps the git history 
pollution to a minimum.

Caveat reviewer:  I'm not an expert of net/ipv4/* code, so I reviewed 
largely from the driver API perspective.

David, thoughts on merging?  I'm not We could stick this into your tree 
or mine.  Whether yours or mine, I would like to keep the driver and 
net-core patches together in the same git tree.

	Jeff



