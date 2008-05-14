Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYENWcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYENWcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755383AbYENWcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:32:25 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:49228 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011AbYENWcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:32:23 -0400
Date: Thu, 15 May 2008 02:32:03 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jamie Lokier <jamie@shareable.org>
Cc: Jeff Garzik <jeff@garzik.org>, Sage Weil <sage@newdream.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Transactions, failover, performance.
Message-ID: <20080514223155.GA19570@2ka.mipt.ru>
References: <20080513174523.GA1677@2ka.mipt.ru> <4829E752.8030104@garzik.org> <20080513205114.GA16489@2ka.mipt.ru> <Pine.LNX.4.64.0805140623001.14334@cobra.newdream.net> <20080514135156.GA23131@2ka.mipt.ru> <482B378C.5070807@garzik.org> <20080514193843.GB10165@2ka.mipt.ru> <20080514215704.GE23758@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514215704.GE23758@shareable.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 10:57:06PM +0100, Jamie Lokier (jamie@shareable.org) wrote:
> 
> If desired, arrange it in a tree to reduce even the microseconds.
> 
> Such network hardware is quite feasible, indeed quite easy with an
> FPGA based NIC.
> 
> Enjoy the speed :-)

And if client-server link is fully saturated by messages
we do not win :) We also lose if client-server is slower than
server-server... I completely agree that there are cases where each
approach is more beneficial, and likely client-to-many os better in
terms of management and/or failover, but for speed there is always a
different side of the coin.

-- 
	Evgeniy Polyakov
