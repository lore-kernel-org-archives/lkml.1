Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZHTL3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZHTL3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 07:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZHTL3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 07:29:31 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:43168 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbZHTL3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 07:29:31 -0400
Message-ID: <4A8D3343.5030502@csr.com>
Date: Thu, 20 Aug 2009 12:28:03 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: stefani@seibold.net
CC: Joe Perches <joe@perches.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 4/7] kfifo: rename kfifo_put... into kfifo_in... and kfifo_get...
 into kfifo_out...
References: <1250714990.13476.3.camel@wall-e> <1250715606.13476.15.camel@wall-e> <1250715819.3407.88.camel@Joe-Laptop.home> <4A8D1E2E.1010006@csr.com> <20090820120310.19332j54j4mf7rry@mail.your-server.de>
In-Reply-To: <20090820120310.19332j54j4mf7rry@mail.your-server.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Aug 2009 11:28:03.0767 (UTC) FILETIME=[481E6C70:01CA2189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stefani@seibold.net wrote:
> Zitat von David Vrabel <david.vrabel@csr.com>:
> 
>> Joe Perches wrote:
>>> On Wed, 2009-08-19 at 23:00 +0200, Stefani Seibold wrote:
>>>> rename kfifo_put... into kfifo_in... to prevent miss use of old  
>>>> non in kernel-tree drivers
>>>> ditto for kfifo_get... -> kfifo_out...
>>> I would have thought
>>> 	kfifo_put -> kfifo_out
>>> 	kfifo_get -> kfifo_in
>>> but maybe that's just me.
>> Use push and pull instead?  In and out (whichever way) isn't obvious enough.
>>
>> David
>>
> 
> As i wrote before: FIFO means first in/first out not first  
> pushed/first pulled nor first put/first get
> It it logical.

In and out aren't verbs.

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


'member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom'
