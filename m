Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbZINIZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbZINIZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 04:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZINIZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 04:25:15 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:56709 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZINIZO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 04:25:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vxoc3eT/l155xuqRORrC10rIaUY2+Qf8MkiKYgEhryJCifPszFO90ZHV508XSy9oAs
         e047VGase22mJaJ8im3S9lrBrKpv3wej4MNhpeqd7bw7FEvaX3hkmkOvHy4PDrkCf/CE
         LdrT3W+ZFRSjZUuxlxRwnWILhE55dLHcfSdf0=
MIME-Version: 1.0
In-Reply-To: <20090914044657.GA4252@merkur.ravnborg.org>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-2-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
	 <8bd0f97a0909131412v6ba29823ube9aab20302aaca0@mail.gmail.com>
	 <94a0d4530909131442h43d0ed1cl9f395f7d38f2c43@mail.gmail.com>
	 <8bd0f97a0909131458r8574620pa539876da969eb5f@mail.gmail.com>
	 <94a0d4530909131504h1a9de951k3719000705a86bbc@mail.gmail.com>
	 <20090914044657.GA4252@merkur.ravnborg.org>
Date: Mon, 14 Sep 2009 11:25:16 +0300
Message-ID: <94a0d4530909140125p73589cffy71a141d234508049@mail.gmail.com>
Subject: Re: [PATCH 2/5] kbuild: fix warning when domainname is not available
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 7:46 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Mon, Sep 14, 2009 at 01:04:11AM +0300, Felipe Contreras wrote:
>> On Mon, Sep 14, 2009 at 12:58 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
>> > .
>> > On Sun, Sep 13, 2009 at 17:42, Felipe Contreras
>> > <felipe.contreras@gmail.com> wrote:
>> >> On Mon, Sep 14, 2009 at 12:12 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
>> >>> On Sun, Sep 13, 2009 at 15:38, Felipe Contreras wrote:
>> >>>> +  if $domain; then
>> >>>
>> >>> is this really correct ?  i think you meant to use:
>> >>> [ -n "$domain" ]
>> >>
>> >> What is the difference?
>> >>
>> >> $domain unset
>> >> test -n "" -> false
>> >> test -> false
>> >>
>> >> $domain is a valid string
>> >> test -n "string" -> true
>> >> test "string" -> true
>> >
>> > except that you didnt invoke `test` anywhere.  you're executing the
>> > contents of $domain.
>>
>> Ahh, I'll update it to:
>> [ "$domain" ]
>
> Please use [ -n "$domain" ].
> Be explicit about what you do.
>
> [Likewise in c we never omit "int" just because we can].

In fact 'int' is implicit of 'signed int', and 'long' is a shorthand
of 'signed long int' and so on. Also, AFAIK 'if (foo)' is preferred
over 'if (foo == true)' or 'if (foo != NULL)' and sometimes even 'if
(foo >= 0)'.

What's the point of going for the explicit form? Make the code less readable?

-- 
Felipe Contreras
