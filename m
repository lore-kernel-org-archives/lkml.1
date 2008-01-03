Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbYACJXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbYACJXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 04:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYACJXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 04:23:07 -0500
Received: from smtp4-g19.free.fr ([212.27.42.30]:47103 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbYACJXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 04:23:05 -0500
Message-ID: <477CA977.2090804@free.fr>
Date: Thu, 03 Jan 2008 10:23:03 +0100
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: neigh: timer & !nud_in_timer
References: <476A6F85.7070905@free.fr>
In-Reply-To: <476A6F85.7070905@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

> I noticed the following message in my kernel log.
> kernel: neigh: timer & !nud_in_timer
> (Might be due to a race condition.)
> 
> I'm running a UP Linux version 2.6.22.1-rt9
> ( http://rt.wiki.kernel.org/index.php )
> 
> The following /proc entries might be relevant.
> 
> /proc/sys/net/ipv4/conf/all/arp_accept
> 0
> /proc/sys/net/ipv4/conf/all/arp_announce
> 2
> /proc/sys/net/ipv4/conf/all/arp_filter
> 0
> /proc/sys/net/ipv4/conf/all/arp_ignore
> 1
> 
> I also lowered the priority of softirq-timer/0 to 10 which means
> it can be interrupted by other IRQ handlers.

Comments or musings?
