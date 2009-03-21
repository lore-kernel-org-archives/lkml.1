Return-Path: <linux-kernel-owner+w=401wt.eu-S1759124AbZCUSa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbZCUSa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 14:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758951AbZCUSar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 14:30:47 -0400
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:4677 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093AbZCUSaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 14:30:46 -0400
Message-ID: <49C53250.4050704@xs4all.nl>
Date: Sat, 21 Mar 2009 19:30:40 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: 2.6.28.2 kernel bug
References: <49C52958.7030700@xs4all.nl> <20090321183141.GA2945@x200.localdomain>
In-Reply-To: <20090321183141.GA2945@x200.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Sat, Mar 21, 2009 at 06:52:24PM +0100, Udo van den Heuvel wrote:
>> While doing a find to get rid of 2.5M smallish files in 1 directory I  
>> got the stuff pasted below which made the system freeze.
>> This is on Fedora 10 on AMD x86_64 with a custom kernel.
>> Any ideas on how to fix this? Can I help?
> 
> Run memtest first.
> 
>> Mar 21 18:27:44 bla kernel: Bad page state in process 'find'
>> Mar 21 18:27:44 bla kernel: page:ffffe20001d4b8e8  
>> flags:0x4000000000080008 mapping:0000000000000000 mapcount:1 count:0
>> Mar 21 18:27:44 bla kernel: Trying to fix it up, but a reboot is needed

Can do, but so far there was no trace of memory error. I can compile 
kernels for days without this bug which hit me for the first time today.
The machine was up for 36 days or so with no other kernel-related 
crash/BUG/etc.
Also the links I posted might point in the direction of a kernel issue?

Kind regards,
Udo
