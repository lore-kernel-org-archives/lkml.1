Return-Path: <linux-kernel-owner+w=401wt.eu-S933225AbZHVHrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933225AbZHVHrg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 03:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932420AbZHVHrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 03:47:35 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:37365 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412AbZHVHrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 03:47:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YCaU1LCnZjzW+x2SYKY03lxDrbP7UCyRUy8+6HvbNaAgCGfIWyaBIObiIOb+YMiJ0h
         soiUkhQPFg4sIF/I1lvUxOb7RPlfqSEYZnn2DGYhBo3KQFXBtp98HBahhZciBboBO7ux
         86Nvp1dYtEj8dL9hKlyBTpJRnRk0PNklaap0Q=
Message-ID: <4A8FA2BD.4030707@gmail.com>
Date: Sat, 22 Aug 2009 00:48:13 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
References: <4A84345D.60506@gmail.com> <20090818104905.GC5231@nowhere>  <20090818160911.GA21243@goodmis.org> <dd18b0c30908180924n3848d32ave258f98a5f703c38@mail.gmail.com> <alpine.DEB.2.00.0908181926410.28398@gandalf.stny.rr.com> <4A8B4607.6090303@gmail.com> <4A8B5113.20102@cn.fujitsu.com>
In-Reply-To: <4A8B5113.20102@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
>>> BTW, how did you get the dmesg? Is it from a clean boot?
>>>
>>> Since it works fine in -rc5 but breaks in -rc6, could you do a git bisect
>>> on it? It shouldn't take too long.
>>>
>>> Thanks,
>>>
>>> -- Steve
>>>
>>>
>>>        
>> well grub2 sure works o.k.
>> the new gfxload is pretty good.
>> problem is the screen just says
>> [Linux-bzImage etc.....]
>> and that's it. (was hoping to make the
>> font smaller to reveal the bug).
>>
>> at this point the only choice I have is to undo
>> commits until I hit the right one.
>>
>>      
>
> You still can do bisect manually. or use quilt?
>
>
>    
Hey alright 2.6.31-rc6 booted.

I must admit, I've been afraid of doing
a git bisect for some time now. but after learning
to do a bisect, I cant see a better solution to finding a
bug(biggest issue I see is having a huge .config).

Anyways the culprit for my issue is this commit:

af6af30c0fcd77e621638e53ef8b176bca8bd3b4

reverting this on rc6 booted the machine up.

Justin P. Mattock
