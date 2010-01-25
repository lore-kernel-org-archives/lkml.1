Return-Path: <linux-kernel-owner+w=401wt.eu-S1752270Ab0AYGO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab0AYGO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 01:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589Ab0AYGOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 01:14:25 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:47718 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab0AYGOY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 01:14:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=eSNMZV5z94c7R2lldvKUPrhR1eA4LNqK8tkuCrpOZH/T2LK7liReqIhYQ0ymAN8sGg
         MMCtrzaRulj5gZ4RY2/0id7DUm0uZStnaylBzPV/82IagssDSHIPKHeBISv5JAg8SezH
         AFqVmqugT66pNwar0OHwcsgwwSFVLz/r3cq4A=
MIME-Version: 1.0
In-Reply-To: <20100122172108.620deddc.akpm@linux-foundation.org>
References: <daef60381001170535q6abfd29cp1b8d07709c00e1db@mail.gmail.com> 
	<20100122172108.620deddc.akpm@linux-foundation.org>
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 25 Jan 2010 14:14:04 +0800
Message-ID: <daef60381001242214i3887f889wf30f34556edd8edc@mail.gmail.com>
Subject: Re: [PATCH] Fix markup_oops.pl get $func_offset error in x8664
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Sam Ravnborg <sam@ravnborg.org>,
       =?ISO-8859-1?Q?Ozan_=C7aglayan?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 09:21, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sun, 17 Jan 2010 21:35:25 +0800
> Hui Zhu <teawater@gmail.com> wrote:
>
>> This patch like the prev patch in http://lkml.org/lkml/2010/1/6/57
>> The x8664 part have the same trouble with it.  This patch is to fix it.
>>
>
> This changelog isn't very useful.  Please provide a description for this
> change which doesn't require that people have to go off and read the
> internet and then work out how some other patch is relevant to this
> one!

OK.  I will post a new mail for this patch.

>
>
>> ---
>>  scripts/markup_oops.pl |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- a/scripts/markup_oops.pl
>> +++ b/scripts/markup_oops.pl
>> @@ -158,7 +158,7 @@ while (<STDIN>) {
>>               $function = $1;
>>               $func_offset = $2;
>>       }
>> -     if ($line =~ /RIP: 0010:\[\<[0-9a-f]+\>\]  \[\<[0-9a-f]+\>\]
>> ([a-zA-Z0-9\_]+)\+(0x[0-9a-f]+)\/0x[a-f0-9]/) {
>> +     if ($line =~ /RIP: 0010:\[\<[0-9a-f]+\>\]  \[\<[0-9a-f]+\>\]
>> ([a-zA-Z0-9\_]+)\+0x([0-9a-f]+)\/0x[a-f0-9]/) {
>>               $function = $1;
>>               $func_offset = $2;
>>       }
>
> Your email client wordwrapped the patch.  Please fix it then resend.
>
>

I will fix it in new mail.  Sorry for it.

Best regards,
Hui
