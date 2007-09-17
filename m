Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbXIQPpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbXIQPpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 11:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbXIQPpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 11:45:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbXIQPpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 11:45:31 -0400
Message-ID: <46EEA115.3090609@redhat.com>
Date: Mon, 17 Sep 2007 11:45:25 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: CPU usage for 10Gbps UDP transfers
References: <20070915190016.GA3868@ics.muni.cz>
In-Reply-To: <20070915190016.GA3868@ics.muni.cz>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> Hello,
> 
> is it expected that application sending 8900bytes datagram through 10Gbps NIC
> utilizes CPU to 100% and similarly the receiver also utilizes CPU to 100%.
> Is it something wrong or this is quite OK?
> 
> (The box is dual single core Opteron 2.4GHz with Myricom 10GE NIC.)

Every time a new generation of ethernet comes out, its peak throughput exceeds 
the memory/CPU/IO capacity of commodity hardware available at the time.  This is 
normal.  Of course, you may not be saturating the link, and it may be possible 
to tune the driver to improve your throughput, but you'll still be saturating a 
CPU on that hardware.

	-- Chris
