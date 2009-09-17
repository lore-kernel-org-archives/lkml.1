Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbZIQAaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbZIQAaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 20:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZIQAaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 20:30:08 -0400
Received: from mail-ew0-f227.google.com ([209.85.219.227]:64751 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZIQAaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 20:30:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=VRmOuXM082orEFwqarfjSb4rdHVgj2rKecWD6yqb1OuggI1Q2cId8qUGFaQzt1dyEO
         ZPD9t8Hm1mn9g5d1HPFeyWXYfwxw4Jo3XmbBFZTMWayPgEJTh/AWk/cmkC9LPSPifu0p
         L2Y0JhOLUDqExbTG7W1YykMJWLdJ8H7E6+MDw=
MIME-Version: 1.0
In-Reply-To: <200908201031.00256.lfpg.dev@gmail.com>
References: <d12c1890908101630m2a4d0d68yf6dc1e0e0e4f4314@mail.gmail.com>
	 <d12c1890908191446k5497d9c8t2f355074eb7ca4ff@mail.gmail.com>
	 <m1k50zi4is.fsf@fess.ebiederm.org>
	 <200908201031.00256.lfpg.dev@gmail.com>
Date: Wed, 16 Sep 2009 21:30:09 -0300
Message-ID: <d12c1890909161730y663fe4f3s5b7e764a53d971ba@mail.gmail.com>
Subject: Re: Flooded by do_IRQ: 0.91 No irq handler for vector
From: Luis Fernando Planella Gonzalez <lfpg.dev@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just to point out that I've upgraded to 2.6.31.0 and the bug is still there...
Just in case the problem is with the VIA board, is there anything
which can be done to try to debug?
--
Luis Fernando Planella Gonzalez

>> > Well, as I've installed sidux, it has upgraded the kernel to 2.6.30.5,
>> > but the error is the same.
>> > I've also tried:
>> > * noapic: the message changes to do_IRQ: 0.55 No irq handler for
>> > vector (irq -1), but then the X server fails to start
>>
>> Interesting...
>>
>> > * noacpi: have no effect on the error message.
>>
>> There is something very strange about your box.  Possibly it is
>> just VIA interrupt controller madness.  VIA has been known
>> to interrupt interrupt related fields in creative ways, and
>> we may be on the edge of another of these.
> Probably. My mother board is an Asus P5VD2-X, which is based on VIA PT890:
> http://br.asus.com/products.aspx?l1=3&l2=11&l3=346&l4=0&model=1362&modelmenu=1 (sorry, link in portuguese)
>
>>
>> I expect it is going to come down to writing a patch to dump out
>> all of the interrupt routing state on the system and to see what
>> is generating the totally unexpected interrupt and then to work our
>> way backwards from there.
>>
>> The fact that the vector number is changing indicates that it is
>> a programmable something that is causing the problem.
>>
>> I'm drawing a blank on which patch to write up.
>>
>> Eric
>>
> Thanks again.
>
> --
> Luis Fernando Planella Gonzalez
>
