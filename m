Return-Path: <linux-kernel-owner+w=401wt.eu-S1945893AbXDEGST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945893AbXDEGST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 02:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161252AbXDEGST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 02:18:19 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53554 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161235AbXDEGSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 02:18:18 -0400
Message-ID: <46149496.5050503@zytor.com>
Date: Wed, 04 Apr 2007 23:17:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, virtualization@lists.osdl.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] Lguest32 print hex on bad reads and writes
References: <1175714071.9371.31.camel@localhost.localdomain>	<1175742090.12230.630.camel@localhost.localdomain>	<72C854B9-1A7F-44C5-9D62-B6B63F3A6DE7@mac.com>	<1175742848.9371.33.camel@localhost.localdomain> <1175744057.12230.632.camel@localhost.localdomain> <46149000.40200@zytor.com>
In-Reply-To: <46149000.40200@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Rusty Russell wrote:
>> On Wed, 2007-04-04 at 23:14 -0400, Steven Rostedt wrote:
>>> On Wed, 2007-04-04 at 23:06 -0400, Kyle Moffett wrote:
>>>
>>>>> (Erk, I wonder what I was thinking when I wrote that?) Can I ask  
>>>>> for %#x (or 0x%x)?  I'm easily confused.
>>>> How about "%p" for pointers?
>>> But that would require casting the numbers to pointers.
>>
>> And the kernel's printk doesn't put 0x on pointers anyway, last I
>> checked 8(
>>
> 
> That's really the bug.  Let's fix it.
> 
>     -hpa

Okay, git tree at:

http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-printk.git;a=summary
git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-printk.git

... will do actual testing and post it to LKML tomorrow.

	-hpa
