Return-Path: <linux-kernel-owner+w=401wt.eu-S1760267AbXJLWFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267AbXJLWFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758753AbXJLWEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:04:52 -0400
Received: from barikada.upol.cz ([158.194.242.200]:54838 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300AbXJLWEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:04:51 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "added: Sam Ravnborg" <sam@ravnborg.org>, Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Redesigning file2alias for easy merging (bits of kbuild/kconfig)
In-Reply-To: <alpine.LFD.0.999.0710112056010.6887@woody.linux-foundation.org>
References: <aday7e9b0m3.fsf@cisco.com> <20071011.181719.78707713.davem@davemloft.net> <alpine.LFD.0.999.0710111944120.6887@woody.linux-foundation.org> <20071012035215.GA10190@suse.de> <alpine.LFD.0.999.0710112056010.6887@woody.linux-foundation.org>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Sat, 13 Oct 2007 00:19:06 +0200
Message-Id: <E1IgSqZ-00032Y-02@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thu, 11 Oct 2007 21:03:14 -0700 (PDT)

> On Thu, 11 Oct 2007, Greg KH wrote:
>
>> On Thu, Oct 11, 2007 at 07:58:04PM -0700, Linus Torvalds wrote:
>> > 
>> > So I merged it all, and I don't expect any problems, but I'm hoping 
>> > somebody is thinking about that mod_devicetable.h/file2alias.c mess.
>> > 
>> > I'm not entirely sure who to blame on that thing. I'm adding Greg to the 
>> > Cc, on the assumption that blaming him is usually the right thing to do ;)
>> 
>> Hey, it wasn't me this time, I haven't even built my trees for you to
>> pull from and break everything yet :)
>
> No, I meant more in the "who the hell is responsible for designing those 
> *files*" rather than who is responsible for the particular merge mess 
> that happened to involve them this time around.
>
>> But yeah, splitting up the mod_devicetable.h/file2alias.c mess is a very
>> good idea, I'll see what I can come up with tomorrow.
>
> I don't think it's a huge issue, but I wanted to bring it up because these 
> days we're normally so good with these kinds of things that it actually 
> stood out a bit. I used to do these kinds of nasty merges all the time 
> with init/main.c and the configuration files, until we split them up.
>
> So I'm certainly perfectly able and used to doing them, it's just that I 
> also think that we have generally learnt to do so much better.
>
> In other words: no hurry or pressure, I just wanted to bring it up, since 
> during the merge I got flashbacks to various "bad old times" that I had 
> hoped we had mostly left behind.
>
> Those files were originally designed/set up by Rusty. I could have blamed 
> him, or perhaps Sam as a kbuild guy, but the reason I cc'd you is that I 
> think this kind of smells like a "device model"ish thing...

If any amount of work will be done on (re)designing, i'd like to propose
documenting all that mod magic.

OK, it can be figured out from the code, and quick split+script_glue can
be "designed". But if goals and key points would be written in plain text
by person(s) who used to do and maintain it, that will be helpful.

Thanks.
____
