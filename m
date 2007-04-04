Return-Path: <linux-kernel-owner+w=401wt.eu-S966275AbXDDCAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966275AbXDDCAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 22:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966276AbXDDCAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 22:00:53 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:52140 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S966275AbXDDCAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 22:00:53 -0400
Date: Tue, 3 Apr 2007 18:32:21 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: David Miller <davem@davemloft.net>, dwmw2@infradead.org,
       flar@allandria.com, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: <Pine.LNX.4.63.0704031817020.21680@qynat.qvtvafvgr.pbz>
Message-ID: <Pine.LNX.4.63.0704031826000.21680@qynat.qvtvafvgr.pbz>
References: <1175644642.10567.31.camel@shinybook.infradead.org><200704032210
 02.GA13210@cynthia.pants.nu><1175648051.10567.61.camel@shinybook.infradead.
 org><20070403.181645.68159458.davem@davemloft.net><20070404022828.5c9b97f3@
 the-village.bc.nu><Pine.LNX.4.63.0704031804350.21680@qynat.qvtvafvgr.pbz>
 <20070404024400.56d016e1@the-village.bc.nu> <Pine.LNX.4.63.0704031817020.21680@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, David Lang wrote:

> so leave all the ports numbered 0-49, but let people who need to know run a 
> tool (even if it's dmesg -s 200000 |grep ttyS) to learn the details of what 
> hardware is used to run what port.

and by the way, this is exactly what I do on machines with different types of 
ethernet cards to figure out what ethX name the different types of cards get. 
after I've figured that out I learn which order the cards of that type are by 
plugging things into a port to see what shows up (knowing the MAC address 
doesn't do you any good if you don't know what hole to plug the wire into)

and yes, the nameing does get messed up when you plugin a new card, or enable a 
driver that you didn't have before, but as painful as that is it's pain that 
only I have to deal with when reconfiguring the hardware, all the other 
sysadmins who use the systems just know what port is what, they don't need to 
know that box A has tulip based quad cards while box B has starfire based quad 
cards, they just know 'eth0 is the one labled 0, eth18 is the one labled 18'

keep it simple for as many people as possible, don't spread the pain. those who 
will feel the pain are already dealing with it and the change to hardware-based 
named doesn't help them anyway.

David Lang
