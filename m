Return-Path: <linux-kernel-owner+w=401wt.eu-S1753265AbZHTFug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbZHTFug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 01:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZHTFug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 01:50:36 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:36719 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbZHTFuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 01:50:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vTqVoo7fI3XlqzeQNESS2mfsKhgFY9SICKs8wV7Rj9suidj8ReOrKMookfxWU5UUBj
         89xvkBR6a96TbdpsM4+S/FMDvs0A5wVX48a8j9AuEExKmPZq9XA/vLhaSuHTQOUecgck
         nN17PGqnQtkhGDKz1WUxV4Ggd4Pw17+hEEj9s=
Message-ID: <4A8CE450.2030703@gmail.com>
Date: Wed, 19 Aug 2009 22:51:12 -0700
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
after going schizo with reverting patches,
I've come down to thinking that this freeze might
  have to do with the tracer merge that happened
a few days ago. (been avoiding that one) I'll have
to revert (If I can) the whole thing to see if this
machine boot's with rc6.
As for perf I reverted everything
up to rc5, and the machine still sticks telling me that
might not be the issue.

Justin P. Mattock


