Return-Path: <linux-kernel-owner+w=401wt.eu-S1762184AbXJRAgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762184AbXJRAgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758595AbXJRAgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:36:14 -0400
Received: from mail.tmr.com ([64.65.253.246]:50749 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758452AbXJRAgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:36:14 -0400
Message-ID: <4716AC65.2070608@tmr.com>
Date: Wed, 17 Oct 2007 20:44:21 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Stefan Monnier <monnier@iro.umontreal.ca>
CC: linux-kernel@vger.kernel.org
Subject: Re: Killing a network connection
References: <jwvodf01b5i.fsf-monnier+gmane.linux.kernel@gnu.org>
In-Reply-To: <jwvodf01b5i.fsf-monnier+gmane.linux.kernel@gnu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Monnier wrote:
> [ I suppose this is not the best place to ask this, but
>   comp.os.linux.networking couldn't come up with a good answer and I can't
>   think of any intermediate step between these two groups ;-( ]
> 
> I'd like (as root, obviously) to kill some of the TCP connections visible
> in netstat.  I've found `tcpkill' and `cutter' but `cutter' only kills TCP
> connections that go *though* the machine (in my case, the machine is not
> a router, so there aren't any such thu connections anyway) and `tcpkill'
> can only kill the conection after seeing some activity (and it doesn't know
> to exit when the connections are killed).  Also those 2 tools seem
> just overkill.
> I'd like simply to do (metaphorically)
> 
>   rm /tcpfs/<foo>
> 
> so it should not need to involve *any* use of the TCP protocol: just kill it
> locally, warn the associated process(es), free the resources and let the
> other end deal with it.
> 
> The main use for me is to deal with dangling connections due to taking
> network interfaces up&down with different IP addresses (typically the wlan0
> interface where the IP is different because I've modes from an AP to
> another).  Of course, maybe there's another way to solve this particular
> problem, in case I'd like to hear about it as well.
> 
I'd like a way to just close TCP connections which are misbehaving in 
some way, not necessarily due to bad intent. I envision some tool which 
would take either IP or IP+port and send an RST to both ends. Yes, I 
could write one, but I bet someone already has. I did something similar 
a few years ago, but the requestor owns the code.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
