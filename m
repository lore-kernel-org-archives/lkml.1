Return-Path: <linux-kernel-owner+w=401wt.eu-S1030205AbYHFTYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030205AbYHFTYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbYHFTYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:24:10 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:33055 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbYHFTYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:24:09 -0400
Message-ID: <2663.69.2.248.210.1218049381.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <4899D6AA.4000501@redhat.com>
References: <200808050626.m756QZ1g003755@wolfmountaingroup.com>   
    <489872C5.2040508@redhat.com>
    <39379.166.70.238.45.1217950104.squirrel@webmail.wolfmountaingroup.com>
    <4899D6AA.4000501@redhat.com>
Date: Wed, 6 Aug 2008 13:03:01 -0600 (MDT)
Subject: Re: [PATCH 2.6.27-rc1-git5 2/26] mdb: correct kprobes int3 trap
From: jmerkey@wolfmountaingroup.com
To: "Masami Hiramatsu" <mhiramat@redhat.com>
Cc: jmerkey@wolfmountaingroup.com, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> jmerkey@wolfmountaingroup.com wrote:
>>> Hi Jeffery,
>>>
>>> Could you explain what is MDB and how it works?
>>
>>
>> MDB is a kernel debugger that uses the same general architecture
>> as the kernel debugger in Netware.  Unlike the variants of GNU
>> debuggers, MDB is geared towards folks from the intel/microsoft worlds
>> who are more accustomed to the old school Intel assembler model and
>> not the GNU variant that looks like an angry typewriter cursing at
>> the screen (%#*&!, etc.).
>
> Would you have any document about MDB, or project-site url?
> I think it is hard for anyone to understand what you like to
> do only from these big patchset.

If you install the patch and enter the debugger, you will find quite
excellent documentation **inside** the debugger.  start with "help help"
at the debugger console.

>
>> MDB has some features not yet in this first patch, but I will be adding
>> to
>> subsequent patches like the ability to create time based traces of
>> execution of code just like an ice does so you can set trigger
>> breakpoints
>> (kdb does not, nor kgdb), then go back ad look what happened in windows
>> of
>> time, as well as a much easier interface, smaller size, more flexible
>> and
>> pluggable command architecture -- a best of all -- it works and does not
>> crash every other release or on every third vendors PC architecture like
>> kdb does all the time.
>
> Would you have talked with kdb/kgdb people?
> Since linux kernel already have kgdb, I think you might better talk
> about merging your functionality (and stability) to kgdb, or at least
> talk about what part both debugger can share.
>
>> It has been in use by me since 1997, when I wrote it after I left
>> Novell.
>> It is mature, hardened, and very stable -- and follows an architecture
>> prove in the industry for over 20 years on Netware.
>
> Out of curiously, is there anyone except for you using MDB?
>
> Thank you,


Network General (now NetScout)
Several Others I do not have authority to name because of NDA agreements.

Jeff




>
>>> And please check your patch style by using scripts/checkpatch.pl.
>>> Your cording style seem to be different from linux coding style...
>>>
>>> Thank you,
>>
>
>
> --
> Masami Hiramatsu
>
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
>
> e-mail: mhiramat@redhat.com
>
>


