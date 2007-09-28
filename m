Return-Path: <linux-kernel-owner+w=401wt.eu-S1761131AbXI1JVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131AbXI1JVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbXI1JVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:21:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54350 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754599AbXI1JVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:21:03 -0400
Date: Fri, 28 Sep 2007 02:20:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux@horizon.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.23-rc8 network problem.  Mem leak?  ip1000a?
Message-Id: <20070928022051.a6f27b1e.akpm@linux-foundation.org>
In-Reply-To: <20070928020617.7389.qmail@science.horizon.com>
References: <20070928020617.7389.qmail@science.horizon.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Sep 2007 22:06:17 -0400 linux@horizon.com wrote:

> Uniprocessor Althlon 64, 64-bit kernel, 2G ECC RAM,
> 2.6.23-rc8 + linuxpps (5.0.0) + ip1000a driver.
> (patch from http://marc.info/?l=linux-netdev&m=118980588419882)
> 
> After a few hours of operation, ntp loses the ability to send packets.
> sendto() returns -EAGAIN to everything, including the 24-byte UDP packet
> that is a response to ntpq.
> 
> ...
>
> Killing and restarting ntpd gets it running again for a few hours.
> Here's after about two hours of successful operation.  (I'll try to
> remember to run slabinfo before killing ntpd next time.)

ntpd.  Sounds like pps leaking to me.

> 
> Can anyone offer some diagnosis advice?
> 

CONFIG_DEBUG_SLAB_LEAK?
