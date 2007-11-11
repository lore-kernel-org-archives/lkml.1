Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbXKKJdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbXKKJdx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 04:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbXKKJdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 04:33:45 -0500
Received: from anchor-post-34.mail.demon.net ([194.217.242.92]:3537 "EHLO
	anchor-post-34.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753413AbXKKJdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 04:33:44 -0500
X-Greylist: delayed 633 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Nov 2007 04:33:44 EST
Message-ID: <4736CA1D.9020507@superbug.co.uk>
Date: Sun, 11 Nov 2007 09:23:41 +0000
From: James Courtier-Dutton <James@superbug.co.uk>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Xavier Bestel <xavier.bestel@free.fr>, Benny Halevy <bhalevy@panasas.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Coding Style: indenting with tabs vs. spaces
References: <4732E6BA.8060001@panasas.com> <20071110120424.GA16067@DervishD> <1194697674.6176.1.camel@bip.parateam.prv> <20071110165017.GB16090@DervishD>
In-Reply-To: <20071110165017.GB16090@DervishD>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

DervishD wrote:
>     Bonjour Xavier :)
>
>  * Xavier Bestel <xavier.bestel@free.fr> dixit:
>   
>> Le samedi 10 novembre 2007 à 13:04 +0100, DervishD a écrit :
>>     
>>>  * Benny Halevy <bhalevy@panasas.com> dixit:
>>>       
>>>> I would like to hear peoples opinion about the indentation convention
>>>> described below that I personally found the most practical with
>>>> several different editors.
>>>>         
>>> While I respect you opinion about tabs, I find tab indentation the most
>>> evil thing ever invented. Even if done right (that is, not indenting
>>> using a mixture of spaces and tabs), the only advantage is that you save
>>> a few bytes.
>>>       
>> Who cares ?
>>     
>
> About the space saving? Not me, of course. It's just that I didn't see
> any other advantage.
>
>   
>> The only advantage is that people can make tabs as big (or as small)
>> as they wish. Tabs become "logical indentation". So one's indentation
>> isn't forced on anotherone's editor.
>>     
>
> The only way of having a sane indentation using tabs is to make sure
> that ALL indentation are tabs, not a mix of tabs and spaces (spaces, if
> any, should be at the end of indentation for aesthetical purposes, but
> should be removed without the logical indentation being lost). A good
> editor can ensure that all indentation are tabs and not a mix, but a
> good editor can adapt indentation to your likings when loading the file
> and save the file translating your favourite indentation back to spaces
> or whatever.
>
> If everybody used tabs correctly, indenting using tabs would be great,
> but IMHO indenting with spaces is much better.
>
>     Raúl Núñez de Arenas Coronado
>
>   

Just use the linux

./scripts/checkpatch.pl --file

It does all the indent checks for you before you submit a patch.
I.e. I checks that one has not mixed tabs with spaces etc.
So, any patches to the Linux kernel will have tabs used correctly.
Where is the problem?

James


