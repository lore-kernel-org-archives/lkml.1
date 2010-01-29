Return-Path: <linux-kernel-owner+w=401wt.eu-S1751247Ab0A2Fpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab0A2Fpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 00:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062Ab0A2Fp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 00:45:29 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:37709 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab0A2Fp2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 00:45:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=iQMg7mFAd/k8UG5wIQYQ2vvNZ28Ty6Vkh3S1YSu8H1KYdnMMaFlJjbGGzCx0v/vbQK
         VUbHSN4wZFGIb5Kv4OYuV27WSucvvF1+1sVDiLvQok9ukzQYtx1PWJCOWUU7P95qN3EH
         mmI4CMrFu9INamgIc+66d2gYDkzuGsRKITD7U=
MIME-Version: 1.0
In-Reply-To: <1264739206.10856.8.camel@Joe-Laptop.home>
References: <4B61357A.5080001@windriver.com> <20100128181240.GA9174@merkur.ravnborg.org> 
	<daef60381001282003q4d43c01dk91c53ec5be17fdf2@mail.gmail.com> 
	<1264739206.10856.8.camel@Joe-Laptop.home>
From: Hui Zhu <teawater@gmail.com>
Date: Fri, 29 Jan 2010 13:45:08 +0800
Message-ID: <daef60381001282145q39f6fcd8s340e1d74f2466426@mail.gmail.com>
Subject: Re: [PATCH] markup_oops.pl: fix get "No matching code found" when 
	first line of range is the faulting instruction
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 12:26, Joe Perches <joe@perches.com> wrote:
> On Fri, 2010-01-29 at 12:03 +0800, Hui Zhu wrote:
>> On Fri, Jan 29, 2010 at 02:12, Sam Ravnborg <sam@ravnborg.org> wrote:
>> > On Thu, Jan 28, 2010 at 02:58:02PM +0800, Hui Zhu wrote:
>> >> Sorry guys, the prev mail for this patch is ugly.
>> >> I make a new mail for it.
>> >
>> > Random updates to scripts/* historically often go
>> > in via the kbuild tree, so Michal added.
>> >
>> >        Sam
>> >
>> > [Kept rest of mail so Michal can see it]
>> >
>> >>
>>
>> Thanks Sam.  And I make a small patch to make get_script.pl can output
>> Michal Marek.
>>
>> Hui
>>
>> Signed-off-by: Hui Zhu <teawater@gmail.com>
>> ---
>>  MAINTAINERS |    4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -3086,6 +3086,10 @@ L:     autofs@linux.kernel.org
>>  S:   Maintained
>>  F:   fs/autofs4/
>>
>> +KERNEL SCRIPT
>> +M:   Michal Marek <mmarek@suse.cz>
>> +F:   scripts/*
>> +
>
> probably not a good idea.
>
> Maybe add
>
> F:      scripts/markup_oops.pl
> F:      scripts/mk*
>
> to KERNEL BUILD
>
>
>

What about this?

Signed-off-by: Hui Zhu <teawater@gmail.com>

---
 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3095,6 +3095,8 @@ S:	Maintained
 F:	Documentation/kbuild/
 F:	Makefile
 F:	scripts/Makefile.*
+F:	scripts/markup_oops.pl
+F:	scripts/mk*

 KERNEL JANITORS
 L:	kernel-janitors@vger.kernel.org
