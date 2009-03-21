Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbZCUShj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbZCUShj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 14:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbZCUSh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 14:37:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:45736 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbZCUSh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 14:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=I0jmLiPqZJtOUJfm2lZ4JFz3/nH7S8HtyGB7bmkPbGSf12GtWa1Z304V/jZIYVmWO9
         5DOWD+ccBTtBPxI65wjcA17bqjr69XcmVcb4yFT5R+tVe+xc1GNfeCP+S1gAQzf58vEz
         xiJ+vBotPp8Z/2ZxoBVHXCarun+rpsIqdtKYk=
Date: Sat, 21 Mar 2009 21:44:42 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28.2 kernel bug
Message-ID: <20090321184442.GA4177@x200.localdomain>
References: <49C52958.7030700@xs4all.nl> <20090321183141.GA2945@x200.localdomain> <49C53250.4050704@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C53250.4050704@xs4all.nl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 07:30:40PM +0100, Udo van den Heuvel wrote:
> Alexey Dobriyan wrote:
>> On Sat, Mar 21, 2009 at 06:52:24PM +0100, Udo van den Heuvel wrote:
>>> While doing a find to get rid of 2.5M smallish files in 1 directory I 
>>>  got the stuff pasted below which made the system freeze.
>>> This is on Fedora 10 on AMD x86_64 with a custom kernel.
>>> Any ideas on how to fix this? Can I help?
>>
>> Run memtest first.
>>
>>> Mar 21 18:27:44 bla kernel: Bad page state in process 'find'
>>> Mar 21 18:27:44 bla kernel: page:ffffe20001d4b8e8   
>>> flags:0x4000000000080008 mapping:0000000000000000 mapcount:1 count:0
>>> Mar 21 18:27:44 bla kernel: Trying to fix it up, but a reboot is needed
>
> Can do, but so far there was no trace of memory error. I can compile  
> kernels for days without this bug which hit me for the first time today.
> The machine was up for 36 days or so with no other kernel-related  
> crash/BUG/etc.
> Also the links I posted might point in the direction of a kernel issue?

Do you have ECC memory?
