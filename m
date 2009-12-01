Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbZLAMxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbZLAMxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 07:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZLAMxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 07:53:09 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60764 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbZLAMxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 07:53:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=t6JJJz/yzLv3EXGldzsQv075XAK+8ZttJIhe4o6f7pSReaNeNHJKeQmsBDYRdCLasG
         QRmQGjVUOczg4imS9OwITkH9qni/nRhJ6vkz9IQijHIkFbsil6g5Cl7sJLSyQ9PBA9xt
         dkLUMR/yQzptEbvKANT7HwZTn9195yyjCB070=
MIME-Version: 1.0
In-Reply-To: <20091130140429.6a93104d@tux.DEF.witbe.net>
References: <20091126193221.3ed8cbf0@tux.DEF.witbe.net>
	 <9b2b86520911300451s63ddc589seb66f3dee48b0cbd@mail.gmail.com>
	 <20091130140429.6a93104d@tux.DEF.witbe.net>
Date: Tue, 1 Dec 2009 12:53:13 +0000
Message-ID: <9b2b86520912010453i74a4806bi8351cf1c77939a43@mail.gmail.com>
Subject: Re: ACPI Exception...
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Paul Rolland <rol@witbe.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/09, Paul Rolland <rol@witbe.net> wrote:
> Hello Alan,
>
> On Mon, 30 Nov 2009 12:51:54 +0000
> Alan Jenkins <sourcejedi.lkml@googlemail.com> wrote:
>
>> On 11/26/09, Paul Rolland <rol@witbe.net> wrote:
>> > Hello,
>> >
>> > I'm seeing the following messages in my logs :
>> >
>> > Nov 26 19:26:27 tux kernel: ACPI Exception: AE_TIME, Returned by
>> > Handler for [EmbeddedControl] (20090903/evregion-424)
>> > Nov 26 19:26:27 tux kernel: ACPI Error (psparse-0537): Method
>> > parse/execution failed [\_SB_.PCI0.LPCB.BAT1._BST] (Node
>> > ffff88013f8182e0), AE_TIME
>> > Nov 26 19:26:27 tux kernel: ACPI Exception: AE_TIME, Evaluating _BST
>> > (20090903/battery-393)
>> >
>> > Is there anything I can do to provide more informations ?
>> >
>> > Regards,
>> > Paul
>>
>> Your kernel version would be a good start :-).
> I'm really stupid :(
> 2.6.32-rc8
>
>> The Embedded Controler driver has seen a series of fixes over time.
>> This error may be fixed for you in the upcoming 2.6.32 release.  So
>> you could try testing a release candidate.
>>
>> It would also be good to tell us the vendor and model of the laptop.
> It's a Dell Vostro 1520, Bios revision 04.
>
> The message itself is "erratic" : it comes up sometimes, with no apparent
> reason (at least so far). It occured twice :
> /var/log/messages-20091129:Nov 26 19:26:27 tux kernel: ACPI Error
> (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.BAT1._BST]
> (Node ffff88013f8182e0), AE_TIME
> /var/log/messages-20091129:Nov 28 18:20:39 tux kernel: ACPI Error
> (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.BAT1._BST]
> (Node ffff88013f8182e0), AE_TIME
>
> but I never got it with previous -rc releases, which is why I got
> surprised, though I can't say it's preventing something to work !
>
> Rgds,
> Paul
>
>
> --
> Paul Rolland                                E-Mail : rol(at)witbe.net
> CTO - Witbe.net SA                          Tel. +33 (0)1 47 67 77 77
> Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
> F-92057 Paris La Defense                    RIPE : PR12-RIPE
> LinkedIn : http://www.linkedin.com/in/paulrolland
>
> This is dedicated to all the ones who want to control Internet, its
> content or its usage :
>
> "I worry about my child and the Internet all the time, even though she's
> too young to have logged on yet. Here's what I worry about. I worry that 10
> or 15 years from now, she will come to me and say 'Daddy, where were you
> when they took freedom of the press away from the Internet?'"
> --Mike Godwin, Electronic Frontier Foundation
>
>
>
