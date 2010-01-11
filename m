Return-Path: <linux-kernel-owner+w=401wt.eu-S1752292Ab0AKC7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab0AKC7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 21:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277Ab0AKC7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 21:59:24 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:36942 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0AKC7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 21:59:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IhF2tQZxgLaGZBu5jFVgcUvk7Vc24+/Wvt8AT6BjjhsN7uTWn3mCL6fs+EbSyk17pU
         FGipgSjbfMbG9QJOU41WkQ1mGDZZxjtlUB6S7PpPX9DdhL7ujYdVQ64pMHdSE9xFsVw7
         hgGWjXbVXLZBhIJYygqxZ7SICSngPV5Mpal7I=
MIME-Version: 1.0
In-Reply-To: <4B45DBB5.9070904@linux.intel.com>
References: <daef60381001060123vbb09aecy7943d72fcb8278a@mail.gmail.com> 
	<4B448EE3.5060200@linux.intel.com> <daef60381001062143i67da4203rb02919b64794664c@mail.gmail.com> 
	<4B45DBB5.9070904@linux.intel.com>
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 11 Jan 2010 10:59:03 +0800
Message-ID: <daef60381001101859t43e336fr149e5a1a11c8f981@mail.gmail.com>
Subject: Re: [PATCH] Fix markup_oops.pl get error in x86
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       =?ISO-8859-1?Q?Ozan_=C7aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

Hui

On Thu, Jan 7, 2010 at 21:03, Arjan van de Ven <arjan@linux.intel.com> wrote:
> On 1/6/2010 21:43, Hui Zhu wrote:
>>
>> What about this version?
>
> looks great to me,
>
> Acked-by: Arjan van de Ven <arjan@linux.intel.com>
>
>>
>> Thanks,
>> Hui
>>
>> ---
>>  scripts/markup_oops.pl |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- a/scripts/markup_oops.pl
>> +++ b/scripts/markup_oops.pl
>> @@ -154,7 +154,7 @@ while (<STDIN>) {
>>        if ($line =~ /RIP: 0010:\[\<([a-z0-9]+)\>\]/) {
>>                $target = $1;
>>        }
>> -       if ($line =~ /EIP is at
>> ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
>> +       if ($line =~ /EIP is at
>> ([a-zA-Z0-9\_]+)\+0x([0-9a-f]+)\/0x[a-f0-9]/) {
>>                $function = $1;
>>                $func_offset = $2;
>>        }
>
>
