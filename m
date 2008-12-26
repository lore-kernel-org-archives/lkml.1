Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbYLZX2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbYLZX2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 18:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYLZX2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 18:28:34 -0500
Received: from main.gmane.org ([80.91.229.2]:49638 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191AbYLZX2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 18:28:34 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [PATCH] Compress kernel modules on installation
Date: Fri, 26 Dec 2008 18:28:22 -0500
Message-ID: <49556896.8070307@tmr.com>
References: <005401c96797$df055100$6602a8c0@bui.materna.com> <alpine.LSU.2.00.0812262134270.12031@fbirervta.pbzchgretzou.qr> <006201c967af$24c29740$6602a8c0@bui.materna.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Jan Engelhardt <jengelh@medozas.de>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
X-Gmane-NNTP-Posting-Host: pool-68-236-142-151.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081217 Fedora/1.1.14-1.fc9 SeaMonkey/1.1.14
In-Reply-To: <006201c967af$24c29740$6602a8c0@bui.materna.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland wrote:
>> On Friday 2008-12-26 21:23, Roland wrote:
>>
>>> what about some "make modules_install_compressed" instead ?
>>>
>>> as i have run out of diskspace quite often when installing test 
>>> kernels, i
>>> think we really need a feature like this.
>>>
>>> i`d also favour the makefile approach.
>>> why another kconfig option?
>>>
>>> jan`s patch looks clean and simple, but i think it`s a little bit 
>>> intrusive...
>>
>> Why so? module-ini
> 
> with "intrusive" i meant, that all modules are now compressed by default 
> and there is no switch to build them uncompressed.
> so you change a long established default which may not be welcomed by 
> everyone and give no option for conservative people.
> 
How many people use the option to install an uncompressed kernel?

> we should take care and not break things.
> default uncompressed, compressed implented as an option is a better 
> strategy, imho.
> discuss changing the default at a later time then.
> 

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

