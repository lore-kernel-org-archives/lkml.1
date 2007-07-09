Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbXGILzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbXGILzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 07:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbXGILzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 07:55:12 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:38755 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbXGILzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 07:55:10 -0400
Message-ID: <4692221B.7050608@dgreaves.com>
Date: Mon, 09 Jul 2007 12:55:07 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: Bruce Allen <ballen@gravity.phys.uwm.edu>
Cc: Mark Lord <liml@rtr.ca>, Douglas Gilbert <dougg@torque.net>,
       Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Dvorak <fermentol@gmail.com>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       Klaus Fuerstberger <kfuerstberger@arcor.de>,
       Bruce Allen <bruce.allen@aei.mpg.de>
Subject: Re: SMART problems in 2.6.22
References: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu>
In-Reply-To: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruce
>> From some of the earlier threads that I missed (below) I have the 
> impression that the problem may be a very simple one, namely that 
> starting with 2.6.22 one needs to run a command to enable SMART when a 
> box is first booted -- the kernel no longer does this as part of the 
> init/setup of the disks. But that is NOT consistent with the first two 
> reports above, which show 'SMART ENABLED'.
> 
> Here are some of the earlier threads that I completely missed:
> 
> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg164863.html
This is mine and although it's a 'real' problem, it is something that's easy to 
hack around by having the suspend script turn on smart after it is resumed. (Of 
course I can't use resume until a skge wol bug is fixed so I won't see/test this 
unless asked too.)

The smart init scripts run '-s on' when the system boots anyway for my system - 
this problem only occurs for me during suspend/resume. Maybe smartd should 
detect that as Alan says.

Please let me know if there's anything else you need.

David


