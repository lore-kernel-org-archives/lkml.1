Return-Path: <linux-kernel-owner+w=401wt.eu-S1765779AbXJRWIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765779AbXJRWIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757354AbXJRWIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:08:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:42138 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482AbXJRWIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:08:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=WPW0Qk6Zi8kRUXTrpSnauc8rp1jRppo4ITljj4PMytJ8JT9pNj/pIYX0UcXzJqpA7dRVbckGrEDYxRs/vaJxG6uYo6ob8kBfm8VQAquPZwNwkxqn3UVRVOWQMaO1oN401xWjhK2qQGh6DZineWOolvt6vl0YifpwZK7Opy1vXRk=
Message-ID: <4717D958.8030900@gmail.com>
Date: Fri, 19 Oct 2007 00:08:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ferenc Wagner <wferi@niif.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: RocketPort Linux driver errors on module reload
References: <bububu786234897832@pripojeni.net> <87k5pozgb5.fsf@tac.ki.iif.hu>	<4713BAD0.9020606@gmail.com> <87myujsdpr.fsf@szonett.ki.iif.hu>	<4af2d03a0710161419n3727dbfev10b1319599d30b49@mail.gmail.com> <87ve94ccnl.fsf@tac.ki.iif.hu>
In-Reply-To: <87ve94ccnl.fsf@tac.ki.iif.hu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2007 11:53 PM, Ferenc Wagner wrote:
> "Jiri Slaby" <jirislaby@gmail.com> writes:
> 
>> On 10/16/07, Wagner Ferenc <wferi@niif.hu> wrote:
>>
>>> Jiri Slaby <jirislaby@gmail.com> writes:
>>>
>>>> Are you willing to test to-pci-probing patches (i.e. patches which
>>>> converts the driver to the model introduced in linux 2.4)?
>>> Well yes.  We've got a copule of such cards, which raises some
>>> interest in a proper driver.  Just send the patches with some
>>> instructions along, or point me to a git branch if you prefer.
>> Maybe the git with stand-alone module would be better...
> 
> Sorry, I don't understand this suggestion.  I don't read LKML, please
> don't suppose any prior knowledge of the jargon used here...  Do you
> mean I should use the bleeding edge git source of the kernel?  Not
> something I'm eager to do, but can do, actually.  And would you send
> me patches separately on top of that?

I meant the creating of a git repository with only the module would be the
easiest possible and most comfortable way for you :). Otherwise I can post you a
patch serie.

>>>> If not, I'll only increment the counter on modprobe and decrement it
>>>> on rmmod, since it would be a safe (in the meaning of not changing
>>>> that much code) way of fixing the problem.
>>> And what are the drawbacks of this simple solution?
>> Nothing, but it's not the proper way -- just a safe fallback. But you
>> can still say no :).
> 
> I expected an improper way to have some disadvantages at least. :)

Yes, if you have pci hotpluggable motherboard :). Pci probing (the new method)
allows you adding/probing pci devices on the fly, not only when the module is
loading.

> Anyway, I can tolerate some glitches during the porting of this
> module, resulting in interruptions of the serial devices, but leaving
> the rest of the system mostly stable; it's a production system after
> all.  If the changes are more threatening, I'll use another system for
> the tests.  In short: suggest a method and let's give a chance for the
> proper solution.  Just please enclose some risk assessment.

I did such switches in drivers several times yet, but I can't assure you, that I
won't make any mistake, but this driver seems not to need too many changes.
Maybe functionality regressions would occur rather than instability of system.

Anyway I would rather wait for the changes from comtrol to not break their
upcoming patches (if they post them in some short term) and then do these changes.

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
