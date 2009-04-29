Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbZD2Hl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbZD2Hl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbZD2HlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:41:18 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:36660 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZD2HlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:41:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w9KwExMM9PgRhf+OMuzCj1p8JZ5Q5/fVdl2rNCfb8D4fzgCVQ7Gvv8NoGzh2QA7uw5
         f7LB0sCYMy+sjyS9cFGImBldvVhJ8HP/96mo1ahC78/1xK47zeCARxcAv+hTsapd9+CP
         FHqx1JJYv9YS2iMA5E2/vZ7DKMuLpmZeu9QC4=
MIME-Version: 1.0
In-Reply-To: <48f7fe350904281736j5ecb6fa8l12426fc17f591551@mail.gmail.com>
References: <4e5e476b0903260847m1de3e976ne20279df359176cf@mail.gmail.com>
	 <9b2b86520903260958r790e5459r553308311522e88f@mail.gmail.com>
	 <4e5e476b0903261454h1525c30chdc86dbcb1cf3cb5c@mail.gmail.com>
	 <9b2b86520903270310x78193514l44b89ed6d3088cf8@mail.gmail.com>
	 <48f7fe350904281736j5ecb6fa8l12426fc17f591551@mail.gmail.com>
Date: Wed, 29 Apr 2009 09:41:14 +0200
Message-ID: <4e5e476b0904290041u6bb475e0o9a409b5e6d83b9ba@mail.gmail.com>
Subject: Re: "ACPI: EC: missing confirmations, switch off interrupt mode" 
	wastes time on startup
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Ryan Hope <rmh3093@gmail.com>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, linux acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey has provided a patch for this. Please look at:
http://bugzilla.kernel.org/show_bug.cgi?id=12949

Corrado

On Wed, Apr 29, 2009 at 2:36 AM, Ryan Hope <rmh3093@gmail.com> wrote:
> I am getting this on my Acer also...
>
> -Ryan
>
> On 3/27/09, Alan Jenkins <sourcejedi.lkml@googlemail.com> wrote:
>> On 3/26/09, Corrado Zoccolo <czoccolo@gmail.com> wrote:
>>> On Thu, Mar 26, 2009 at 5:58 PM, Alan Jenkins
>>> <sourcejedi.lkml@googlemail.com> wrote:
>>>> On 3/26/09, Corrado Zoccolo <czoccolo@gmail.com> wrote:
>>>>
>>>> Currently there is no option to force polling, sorry.  I'm _guessing_
>>>> this was a deliberate omission.  But I can sympathise that even 0.5s
>>>> boot delay is bad on a netbook.
>>>>
>>> Yes. Do you think that changing olpc_ec_timeout kernel parameter may
>>> help in getting the timeout sooner?
>>>
>>
>> No, that's something different.  There's no boot option to change the
>> timeout.
>>
>>>> Feel free to create a new bugzilla entry.  You can attach the full
>>>> output of dmesg, but acpidump is probably not required.  What would be
>>>> really helpful is if you could file on bugzilla, and attach a full
>>>> debug trace.  I.e. as well as the normal dmesg, attach the dmesg
>>>> output after recompiling with this change:
>>>>
>>>
>>> bug: http://bugzilla.kernel.org/show_bug.cgi?id=12949
>>> full debug dmesg: http://bugzilla.kernel.org/attachment.cgi?id=20695
>>
>> Great.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
