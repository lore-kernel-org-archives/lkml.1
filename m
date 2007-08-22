Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbXHVBpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbXHVBpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 21:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbXHVBpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 21:45:30 -0400
Received: from ns.miraclelinux.com ([219.118.163.66]:33482 "EHLO
	mail.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbXHVBp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 21:45:29 -0400
Message-ID: <46CB9537.10503@miraclelinux.com>
Date: Wed, 22 Aug 2007 10:45:27 +0900
From: Kiyoshi Sasaki <ksasaki@miraclelinux.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] on the system with companion host controller,
 error -71 returns
References: <Pine.LNX.4.44L0.0708211036480.4137-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0708211036480.4137-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.8.21.181724
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan

Thank you for your comment. I'll try to change the load order.

-- 

Kiyoshi Sasaki <ksasaki@miraclelinux.com>

> On Tue, 21 Aug 2007, Kiyoshi Sasaki wrote:
> 
>> Hello,
>>
>> I see below errors in dmesg on ICH6/ICH7 machine:
>>
>> usb 1-1: device not accepting address 2, error -71
>> or
>> usb 1-1: device descriptor read/all, error -71
>>
>> I'm trying to debug it, but by now I can't make it.
>> Can you give me your help ?
> 
> There's nothing to debug; these messages are perfectly normal.  If you 
> want to prevent them from occurring, you should change the load order 
> of your modules: Load ehci-hcd before uhci-hcd.
> 
> Alan Stern
> 
> 
