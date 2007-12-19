Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbXLSI5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbXLSI5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 03:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbXLSI46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 03:56:58 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:64845 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbXLSI45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 03:56:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type:from;
        b=KR2HZWoZlquBec+y1iKgq1uPzm2wFralA4aHdsk3hJ8/+X0JZp7UBF+0b2qosM/GcBQBJyZa0ZijgUTu980rumRp285EHAXP30M33UBOc4mL6ov1O/LZ+CrFZmKqSnmInw0flkApJjl+QJYx1bHHjTQwGC0kexg8+uBpBlmCt3U=
Date: Wed, 19 Dec 2007 03:56:46 -0500 (EST)
To: Nico Schottelius <nico-kernel-20071219@schottelius.org>
cc: Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Out of memory and no killable processes: 2.6.22-2-686-bigmem
In-Reply-To: <20071219055550.GE21042@denkbrett.schottelius.org>
Message-ID: <Pine.LNX.4.64.0712190340090.8597@mini.warudkars.net>
References: <fa.oSel00y9Hn5hvV3laxPiw9blEfU@ifi.uio.no> <4768692A.3030204@shaw.ca>
 <20071219055550.GE21042@denkbrett.schottelius.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: Parag Warudkar <parag.warudkar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007, Nico Schottelius wrote:

>> If you're running tons of memory, it
>> really is better to run a 64-bit kernel if possible.
>
> Sure? Afaik that results in a bit slower access to memory and appart
> from being able to address MUCH more memory doesn't change the
> situation.

No, generally 64-bit x86 does not slow down things - it might speed things 
up a bit due to more accessible registers in 64-bit mode. And it does 
change the situation from VM PoV a lot. In (bearded) God's own words - 
"... run a 64bit kernel and then the kernel isn't trying the software equivalent of 
managing a filing cabinet through the keyhole."

You will find this recent thread on same topic useful - 
http://lkml.org/lkml/2007/12/17/7 .


> Perhaps I missed something.
>
> And updating to 64 Bit kernel also implies changing the userland, so
> a reinstall would be necessary, wouldn't it?

May not be necessary - I recently tried installing Fedora 8 32-bit/PAE on 
a 8Gb Core 2 box and then upgrading just the kernel to 64-bit and it worked 
fine except for the 32-bit iptables service having problems running on 
64-bit kernel. [Also I hear the closed source nVidia binaries will not 
work on this setup - so if you don't need such things you will be able to 
go to a 64-bit kernel w/o reinstalling userspace.]

>> I believe there are
>> some cases where low memory can be pretty easily exhausted on machines with
>> lots of high memory.
>
> Some minutes ago the third machine of that type freezed.
> with 7 GiB of *free* memory, before getting oom+panic.
>
> Is it possible to debug this issue somehow?

Like said in the above thread I referred to you might have better luck 
with RHEL/CentOS or other "Enterprise" kernels if you want to stick to 
32-bit. But the pain is not worthwhile - give 64-bit kernel a shot.

HTH

Parag
