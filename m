Return-Path: <linux-kernel-owner+w=401wt.eu-S932462AbZKBWCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbZKBWCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 17:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbZKBWCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 17:02:10 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:34638 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756858AbZKBWCJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 17:02:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D50WTDf97z3LauWLe36wmAX3akCoxy6ogcDPKc0o0uFmWRyGWhtfTDIr+e9bXnfHd+
         fibha+9+hF0wyAvN5PJy4khS9RmumM23ZMLoc2lDwWeNECtO29/9Zb/w+yxk2hGrrYxm
         4MmvOPmRQc/BxZWvIAvrKqO3s+sOHIia+GGOA=
MIME-Version: 1.0
In-Reply-To: <4AEF53F5.4020107@gmail.com>
References: <dd18b0c30911021329g3c99a783n6b0a293240c3312c@mail.gmail.com>
	 <4AEF53F5.4020107@gmail.com>
Date: Mon, 2 Nov 2009 14:02:14 -0800
Message-ID: <dd18b0c30911021402t6c8b9cd4p2e5d5dcad732d0ac@mail.gmail.com>
Subject: Re: cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
From: Justin Mattock <justinmattock@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 2, 2009 at 1:49 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 11/02/2009 10:29 PM, Justin Mattock wrote:
>> [  532.942324] cc1plus invoked oom-killer: gfp_mask=0x280da, order=0, oom_adj=0
>> [  532.942330] Pid: 16002, comm: cc1plus Tainted: P
>> 2.6.32-rc5-00083-g04ea458 #2
>> [  532.942333] Call Trace:
>> [  532.942342]  [<ffffffff810bce11>] T.417+0x7c/0x245
>> [  532.942347]  [<ffffffff810bd11c>] __out_of_memory+0x142/0x159
>> [  532.942352]  [<ffffffff810bd1a1>] out_of_memory+0x6e/0x9d
>> [  532.942357]  [<ffffffff810c0086>] __alloc_pages_nodemask+0x47e/0x5cc
>> [  532.942363]  [<ffffffff810d2115>] handle_mm_fault+0x25d/0x68e
>> [  532.942369]  [<ffffffff813dfc1d>] do_page_fault+0x2bb/0x2d3
>> [  532.942373]  [<ffffffff813ddb25>] page_fault+0x25/0x30
> ...
>> [  532.957951] Out of memory: kill process 16001 (c++) score 543727 or a child
>> [  532.957955] Killed process 16002 (cc1plus)
>>
>> I just compiled the latest gcc snapshot a few days
>> ago.
>
> How many jobs did you run in parallel? Was there anything else memory
> consuming running on that machine? Do you run the same jobs count every
> time you compile such big c++ projects?
>

This would be the only job running.

as for other types of jobs under ps aux there's only
udev,dbus,acpid,sshd,wicd running.

Now with this oom-killer I'm
hitting this on an imac9,1 with
gcc (GCC) 4.5.0 20091029 (experimental)
2.6.32-rc5-00083-g04ea458

On my other machine macbook pro ati chipset
(same system pure64)firefox seems to be going a lot farther
than on the imac(doing this in the past I think this takes a good
45min to compile).

the macbook has:
gcc (GCC) Cross-LFS 4.4.1.20090722) 4.4.1
2.6.32-rc4-00039-ga3f6f2e



-- 
Justin P. Mattock
