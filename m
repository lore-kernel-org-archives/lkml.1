Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbYENTIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbYENTIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 15:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758379AbYENTIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 15:08:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41996 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbYENTIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 15:08:15 -0400
Message-ID: <482B3899.9070008@garzik.org>
Date: Wed, 14 May 2008 15:08:09 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: Jamie Lokier <jamie@shareable.org>, Sage Weil <sage@newdream.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Transactions, failover,
 performance.
References: <20080513174523.GA1677@2ka.mipt.ru> <4829E752.8030104@garzik.org> <20080513205114.GA16489@2ka.mipt.ru> <Pine.LNX.4.64.0805140623001.14334@cobra.newdream.net> <20080514135156.GA23131@2ka.mipt.ru> <20080514143105.GB14987@shareable.org> <20080514150052.GA15826@2ka.mipt.ru>
In-Reply-To: <20080514150052.GA15826@2ka.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> That can be the case if client connects to some gate server, which in
> turn broadcasts data further, that is how I plan to implement things at
> first.

That means you are less optimal than the direct-to-storage-server path 
in NFSv4.1, then........

<waves red flag in front of the bull>

If access controls permit, the ideal would be for the client to avoid an 
intermediary when storing data.  The client only _needs_ a consensus 
reply that their transaction was committed.  They don't necessarily need 
an intermediary to do the boring data transfer work.

	Jeff



