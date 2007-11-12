Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbXKLINd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbXKLINd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 03:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbXKLINZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 03:13:25 -0500
Received: from sa14.bezeqint.net ([192.115.104.29]:33000 "EHLO
	sa14.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbXKLINY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 03:13:24 -0500
Message-ID: <47380B14.3010604@panasas.com>
Date: Mon, 12 Nov 2007 10:13:08 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: James Courtier-Dutton <James@superbug.co.uk>
CC: Xavier Bestel <xavier.bestel@free.fr>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Coding Style: indenting with tabs vs. spaces
References: <4732E6BA.8060001@panasas.com> <20071110120424.GA16067@DervishD> <1194697674.6176.1.camel@bip.parateam.prv> <20071110165017.GB16090@DervishD> <4736CA1D.9020507@superbug.co.uk>
In-Reply-To: <4736CA1D.9020507@superbug.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov. 11, 2007, 11:23 +0200, James Courtier-Dutton <James@superbug.co.uk> wrote:
> DervishD wrote:
>>     Bonjour Xavier :)
>>
>>  * Xavier Bestel <xavier.bestel@free.fr> dixit:
>>   
>>> Le samedi 10 novembre 2007 à 13:04 +0100, DervishD a écrit :
>>>     
>>>>  * Benny Halevy <bhalevy@panasas.com> dixit:
>>>>       
>>>>> I would like to hear peoples opinion about the indentation convention
>>>>> described below that I personally found the most practical with
>>>>> several different editors.
>>>>>         
>>>> While I respect you opinion about tabs, I find tab indentation the most
>>>> evil thing ever invented. Even if done right (that is, not indenting
>>>> using a mixture of spaces and tabs), the only advantage is that you save
>>>> a few bytes.
>>>>       
>>> Who cares ?
>>>     
>> About the space saving? Not me, of course. It's just that I didn't see
>> any other advantage.
>>
>>   
>>> The only advantage is that people can make tabs as big (or as small)
>>> as they wish. Tabs become "logical indentation". So one's indentation
>>> isn't forced on anotherone's editor.
>>>     
>> The only way of having a sane indentation using tabs is to make sure
>> that ALL indentation are tabs, not a mix of tabs and spaces (spaces, if
>> any, should be at the end of indentation for aesthetical purposes, but
>> should be removed without the logical indentation being lost). A good
>> editor can ensure that all indentation are tabs and not a mix, but a
>> good editor can adapt indentation to your likings when loading the file
>> and save the file translating your favourite indentation back to spaces
>> or whatever.
>>
>> If everybody used tabs correctly, indenting using tabs would be great,
>> but IMHO indenting with spaces is much better.
>>
>>     Raúl Núñez de Arenas Coronado
>>
>>   
> 
> Just use the linux
> 
> ./scripts/checkpatch.pl --file
> 
> It does all the indent checks for you before you submit a patch.
> I.e. I checks that one has not mixed tabs with spaces etc.
> So, any patches to the Linux kernel will have tabs used correctly.
> Where is the problem?

checkpatch allows to indent with any number of tabs and up to 7 spaces.
This is consistent with Documentation/CodingStyle and therefore can be
considered "correct".  However, forcing everybody to the same tab expansion
setup is too limiting, especially when working in several environments
at the same time where some of them may not be the linux kernel.

Using only spaces as DervishD suggested works around that using brute force
by forcing the user to the author's preference which is legitimate but
may not be the most productive way.

I think that my proposal of using tabs as logical indents only (as Xav put it)
and spaces for decorative alignment provides the best of both worlds.
One can expand the tabs to any number of spaces as one likes and then
the trailing spaces will work on any editor setup as long as you use
fixed-width font.  That's not considered "correct" as per checkpatch but
works much better for me.

Benny

> 
> James
> 
> 
> -

