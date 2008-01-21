Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbYAUIVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbYAUIVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 03:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbYAUIVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 03:21:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:29548 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543AbYAUIVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 03:21:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=tTa+086TT39/aoaQWr0KpIqEYv9rpEAK8VaFdSC8SA+1VdVRi+HvutguYRJ3i+mo4bPVKdQ0GgHAY5ehepJNzzztZ4bx+jGbaY2jeS60Tw99RHLZ7jGnwO8NhmFENTCQlsGR5qaJVYXYGdV53zd36vk8eG0sgFGqT0X3IFAaZAg=
Message-ID: <4794560C.6010302@gmail.com>
Date: Mon, 21 Jan 2008 09:21:32 +0100
From: Joe <zentrale.at.work@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Rafael Sisto <rafael.sisto@gmail.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: create a file in kernel mode. help please!
References: <ee3dc96c0801182116q3d54148dl6773d76ff3160d91@mail.gmail.com> <ee3dc96c0801182117t6e40b46fr1b2d5826e22a7124@mail.gmail.com>
In-Reply-To: <ee3dc96c0801182117t6e40b46fr1b2d5826e22a7124@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael.

Probably you haven't got any answers yet because you should NEVER EVER 
(i repeat: NEVER EVER, not even in college projects) go for file I/O in 
the kernel. You might want to think the whole thing over one or two 
times, i think.

If it comes to you that it is absolutely necessary (i repeat again: 
ABSOLUTELY NECESSARY, like a solution to feed the world) then you might 
google for some ancient FAQ of Greg (K-H) (i think he was) where he 
tries to give a little more details about this kind of problem, and also 
gives a possible solution, IIRC. Sorry that i don't remember the exact 
page/adress anymore, for i intend never to look at it again.

Greetz
Joe

Rafael Sisto schrieb:
> Hi there,
> obviously this is a newbie question, but I couldn't find any
> documentation on how to do it.. I tried several ways but couldnt do
> it.
> I designed a system call, so a user will call it, and a new file will
> be created ('/tmp/filexx'). After that, I have another system call,
> that will map the file into the maps of the user process. The idea is
> the same as IPC...
> 
> I managed to create the file with this function (in the first system call):
>         fd = filp_open(path, O_CREAT | O_RDWR , 777);
> 
> After that, the user will call another system call, and it will map
> this file to the process maps.
> something like this:
>          filp_open(route, O_RDWR,0 );
>          do_mmap(fp, 0, tamano, PROT_READ | PROT_WRITE | PROT_EXEC,
> MAP_SHARED, 0);
> 
> After I call the second system call, the user tries to access the
> memory, but gets the message "Bus Error".
> I tried to manually create a file with vi, and then use the second
> system call, and worked perfectly. I could use the shared memory
> without problems.
> 
> The problems seems to be in the first system call (with filp_open),
> when I try to create a new file... Can somebody suggest me something,
> on how I could fix this issue?? It is very important because it is for
> a college projects.
> 
> Greetings, and thanks in advance for the answers.
> Rafael Sisto - Uruguay.-
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Sepp "ZaP" Holzmayr

please reply to:
zentrale.at.work@gmail.com

watch out for:
www.rocksociety.de
