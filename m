Return-Path: <linux-kernel-owner+w=401wt.eu-S1762656AbXJRVyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762656AbXJRVyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 17:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756705AbXJRVx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 17:53:58 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:54813 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482AbXJRVx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 17:53:58 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: "Jiri Slaby" <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RocketPort Linux driver errors on module reload
References: <bububu786234897832@pripojeni.net> <87k5pozgb5.fsf@tac.ki.iif.hu>
	<4713BAD0.9020606@gmail.com> <87myujsdpr.fsf@szonett.ki.iif.hu>
	<4af2d03a0710161419n3727dbfev10b1319599d30b49@mail.gmail.com>
Date: Thu, 18 Oct 2007 23:53:50 +0200
In-Reply-To: <4af2d03a0710161419n3727dbfev10b1319599d30b49@mail.gmail.com>
	(Jiri Slaby's message of "Tue, 16 Oct 2007 23:19:28 +0200")
Message-ID: <87ve94ccnl.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Jiri Slaby" <jirislaby@gmail.com> writes:

> On 10/16/07, Wagner Ferenc <wferi@niif.hu> wrote:
>
>> Jiri Slaby <jirislaby@gmail.com> writes:
>>
>>> Are you willing to test to-pci-probing patches (i.e. patches which
>>> converts the driver to the model introduced in linux 2.4)?
>>
>> Well yes.  We've got a copule of such cards, which raises some
>> interest in a proper driver.  Just send the patches with some
>> instructions along, or point me to a git branch if you prefer.
>
> Maybe the git with stand-alone module would be better...

Sorry, I don't understand this suggestion.  I don't read LKML, please
don't suppose any prior knowledge of the jargon used here...  Do you
mean I should use the bleeding edge git source of the kernel?  Not
something I'm eager to do, but can do, actually.  And would you send
me patches separately on top of that?

>>> If not, I'll only increment the counter on modprobe and decrement it
>>> on rmmod, since it would be a safe (in the meaning of not changing
>>> that much code) way of fixing the problem.
>>
>> And what are the drawbacks of this simple solution?
>
> Nothing, but it's not the proper way -- just a safe fallback. But you
> can still say no :).

I expected an improper way to have some disadvantages at least. :)

Anyway, I can tolerate some glitches during the porting of this
module, resulting in interruptions of the serial devices, but leaving
the rest of the system mostly stable; it's a production system after
all.  If the changes are more threatening, I'll use another system for
the tests.  In short: suggest a method and let's give a chance for the
proper solution.  Just please enclose some risk assessment.
-- 
Regards,
Feri.
