Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbXI1Wm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbXI1Wm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 18:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbXI1Wmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 18:42:51 -0400
Received: from mail.tmr.com ([64.65.253.246]:33683 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176AbXI1Wmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 18:42:50 -0400
Message-ID: <46FD84AF.8010506@tmr.com>
Date: Fri, 28 Sep 2007 18:48:15 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: lnx-kern@soo.com
CC: Kernel Mailing list <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Network sky2 Module, kernel version 2.6.23-rc7
References: <46E2BC6A.4070800@gmx.de>	<46EF4DE1.4000707@soo.com>	<46EFE09B.6090901@tmr.com> <20070918080525.7a49d110@freepuppy.rosehill.hemminger.net> <46F21692.4020607@soo.com> <46F5C7B4.7050802@soo.com>
In-Reply-To: <46F5C7B4.7050802@soo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ben soo wrote:
> i spoke too soon.  The Gbit interface still dies.  Lasted around 19hrs. 
> or so.  i can't tell if there are hardware issues: yesterday a Gbit NIC 
> on the firewall died.  Different chip (Realtek), different driver, 
> different machine, same segment.  Segment is a mix of 100Mbit and 1Gbit 
> machines.
> 
> Symptoms of the failure are it just stops functioning with no error 
> messages.  ifconfig says there are packets being TX'd and none being 
> RX'd.  Interface can't be brought up again.
> 

If you search through my exchanges with Adrian Bunk WRT sk98lin removal, 
I mentioned a very similar problem. When I wrote that I had some notes 
in front of me, which are now archived and not quickly available. 
unloading and reloading the modules didn't fix it, IIRC.

I will be doing an update on the machine in question by the end of the 
year, and at that time I will try shy2 again, since I'll be able to do 
better testing.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
