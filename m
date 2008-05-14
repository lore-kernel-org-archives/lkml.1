Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYENVtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYENVtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYENVtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:49:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52546 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbYENVti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:49:38 -0400
Message-ID: <482B5E6F.4020204@garzik.org>
Date: Wed, 14 May 2008 17:49:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sage Weil <sage@newdream.net>
CC: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Transactions, failover,
 performance.
References: <20080513174523.GA1677@2ka.mipt.ru> <4829E752.8030104@garzik.org> <20080513205114.GA16489@2ka.mipt.ru> <Pine.LNX.4.64.0805140623001.14334@cobra.newdream.net> <482B2E50.2030601@garzik.org> <Pine.LNX.4.64.0805141247180.23143@cobra.newdream.net>
In-Reply-To: <Pine.LNX.4.64.0805141247180.23143@cobra.newdream.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage Weil wrote:
> You mean if, say, some verifiable metadata or a trusted third party stores 
> that checksum?  Sure.  This is just pushing the what-has-committed 

Yes.


> information to some other party, though, who will presumably face the same 
> problem of requiring a majority for verifiable correctness.  This is more 
> or less what most people do in practice... using Paxos for critical state 
> and piggybacking the rest of the system's consistency off of that.

More like receiving a guarantee of consensus (just like any signature on 
data), while only needing to be able to communicate with a single node.


>>> (This is why Paxos is typically used only for critical cluster
>>> configuration/state, not regular data.)
>> Yep, I'm working on a config daemon a la Chubby or zookeeper, based on Paxos,
>> that does just this.  :)
> 
> Cool.  Do you have a URL?  I'd be interested in seeing how you diverge 
> from classic paxos.  For Ceph's monitor daemon, the main requirements 
> (besides strict correctness guarantees) were scalable (distributed) read 
> access, and a history of state changes.  Nothing too unusual.

Is there a URL?  Yes.  http://linux.yyz.us/projects/cld.html

It it useful?  No.  It's just a skeleton code right now.  I am 
experimenting with various Paxos algorithms as we speak, which is why 
it's fresh in my mind at the moment.

I also forgot to mention hyperspace, which is another up-and-coming 
player in this area, alongside Chubby and zookeeper.

	Jeff



