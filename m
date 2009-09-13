Return-Path: <linux-kernel-owner+w=401wt.eu-S1751923AbZIMWEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbZIMWEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 18:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbZIMWEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 18:04:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:29308 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZIMWEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 18:04:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V0Mlt1ZDGwhFeMtb5oXsI/H3VrCXkDgKUcvzWj+nSIkW9sTAJK95A4UjDMLRgKgeZC
         0lgb50ragfBCtaOgNAtuNX57VFNEhWE6T9gFW/svfwyxIQjF+IE0JwIJU23Pdy3p7DDm
         JZsvva0IPzgb3PwDSBEafNoA9MUaNXHjjmvcU=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0909131458r8574620pa539876da969eb5f@mail.gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-2-git-send-email-felipe.contreras@gmail.com>
	 <1252870707-4824-3-git-send-email-felipe.contreras@gmail.com>
	 <8bd0f97a0909131412v6ba29823ube9aab20302aaca0@mail.gmail.com>
	 <94a0d4530909131442h43d0ed1cl9f395f7d38f2c43@mail.gmail.com>
	 <8bd0f97a0909131458r8574620pa539876da969eb5f@mail.gmail.com>
Date: Mon, 14 Sep 2009 01:04:11 +0300
Message-ID: <94a0d4530909131504h1a9de951k3719000705a86bbc@mail.gmail.com>
Subject: Re: [PATCH 2/5] kbuild: fix warning when domainname is not available
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 12:58 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> .
> On Sun, Sep 13, 2009 at 17:42, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>> On Mon, Sep 14, 2009 at 12:12 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
>>> On Sun, Sep 13, 2009 at 15:38, Felipe Contreras wrote:
>>>> +  if $domain; then
>>>
>>> is this really correct ?  i think you meant to use:
>>> [ -n "$domain" ]
>>
>> What is the difference?
>>
>> $domain unset
>> test -n "" -> false
>> test -> false
>>
>> $domain is a valid string
>> test -n "string" -> true
>> test "string" -> true
>
> except that you didnt invoke `test` anywhere.  you're executing the
> contents of $domain.

Ahh, I'll update it to:
[ "$domain" ]

-- 
Felipe Contreras
