Return-Path: <linux-kernel-owner+w=401wt.eu-S1752017AbXDDQJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbXDDQJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXDDQJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:09:29 -0400
Received: from terminus.zytor.com ([192.83.249.54]:37327 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbXDDQJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:09:28 -0400
Message-ID: <4613CD34.8080509@zytor.com>
Date: Wed, 04 Apr 2007 09:07:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: David Lang <david.lang@digitalinsight.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       dwmw2@infradead.org, flar@allandria.com, paulus@samba.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
References: <1175644642.10567.31.camel@shinybook.infradead.org><200704032210 02.GA13210@cynthia.pants.nu><1175648051.10567.61.camel@shinybook.infradead. org><20070403.181645.68159458.davem@davemloft.net><20070404022828.5c9b97f3@ the-village.bc.nu><Pine.LNX.4.63.0704031804350.21680@qynat.qvtvafvgr.pbz> <20070404024400.56d016e1@the-village.bc.nu> <Pine.LNX.4.63.0704031817020.21680@qynat.qvtvafvgr.pbz>
In-Reply-To: <Pine.LNX.4.63.0704031817020.21680@qynat.qvtvafvgr.pbz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Lang wrote:
> On Wed, 4 Apr 2007, Alan Cox wrote:
> 
>>>> You don't get machines with 64 ethernet ports on add-in cards. There 
>>>> are
>>>> good reasons for the naming schemes in use.
>>>
>>> I've seen machines offering up to 48, what's the magic number that 
>>> makes you
>>> need to chagne nameing schemes?
>>
>> Have you tried working with 48 ports when they are not numbered 0-47 or
>> in some logical fashion ?
> 
> no, but that's what we're wanting with serial ports as well. a system 
> with 50 serial ports should have them numbered 0-49, not typea0-5, 
> typeb0-39, typec0-5
> 

I would actually disagree.  I have systems with multiport serial cards 
installed, and I much prefer those to be named differently.  Not only do 
I not have to worry about the same problem I *constantly* have with 
onboard Ethernet cards -- whoops I just installed an expansion card and 
suddenly my onboard NIC is eth2! -- but the expansion serial ports tend 
to be *different.*

For example, on my serial server, the Cyclades ports (ttyC*) use RJ-45 
connections from an external expansion module, whereas of course the 
builtin ones (ttyS*) use DB-9s.

	-hpa
