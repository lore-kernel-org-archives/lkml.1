Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbXJCR7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbXJCR7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 13:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757169AbXJCR7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 13:59:00 -0400
Received: from mail.tmr.com ([64.65.253.246]:38382 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757098AbXJCR67 (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 13:58:59 -0400
Message-ID: <4703D9B6.109@tmr.com>
Date: Wed, 03 Oct 2007 14:04:38 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.network,gmane.linux.kernel
To: pomac@vapor.com
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>, Linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] sky2: jumbo frame regression fix
References: <1191372129.26233.12.camel@localhost>	 <20071002180209.47c350a3@freepuppy.rosehill> <1191375274.26233.17.camel@localhost>
In-Reply-To: <1191375274.26233.17.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kumlien wrote:
> On tis, 2007-10-02 at 18:02 -0700, Stephen Hemminger wrote:
>> Remove unneeded check that caused problems with jumbo frame sizes.
>> The check was recently added and is wrong.
>> When using jumbo frames the sky2 driver does fragmentation, so
>> rx_data_size is less than mtu.
> 
> Confirmed working.
> 
> Now running with 9k mtu with no errors, =)

Have you verified that you are actually getting jumbo packets out of the 
NIC? I had one machine which did standard packets silently using sky2 
and jumbo using sk98lin. I was looking for something else with tcpdump 
and got one of those WTF moments when I saw all the tiny packets.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
