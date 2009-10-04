Return-Path: <linux-kernel-owner+w=401wt.eu-S1756961AbZJDX6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961AbZJDX6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 19:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZJDX6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 19:58:49 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:58345 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbZJDX6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 19:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xytbo73kBUucSNgC4HWAIB9QcsMTIgFQvOtAzILr8jusBBvnZmZ5kc6th3SSr9Kvbr
         sYUViDwAmvkmtt2XGwKNJfBUPpxzhw8mKkDDslP6+EtCRgIpWoPvMPpAMfp5s1jvwACb
         4K6k6lWG382TgWhuwoxA/C97qUtzVfLMW/l0g=
MIME-Version: 1.0
In-Reply-To: <4AC92837.80708@suse.de>
References: <1254669853.26496.0.camel@carter> <200910042246.23712.rjw@sisk.pl>
	 <4AC91578.2020807@suse.de> <200910050043.56667.rjw@sisk.pl>
	 <4AC92837.80708@suse.de>
Date: Mon, 5 Oct 2009 01:58:10 +0200
Message-ID: <ca2dc2820910041658w18a5b37drcb4328f35f135e7a@mail.gmail.com>
Subject: Re: [PATCH] battery: Fix charge_now returned by broken batteries
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 5, 2009 at 12:56 AM, Alexey Starikovskiy
<astarikovskiy@suse.de> wrote:
> Rafael J. Wysocki пишет:
>>
>> On Sunday 04 October 2009, Alexey Starikovskiy wrote:
>>>
>>> Hi Rafael,
>>
>> Alex,
>>
>>> This is not my rule, it was/is the rule of power device class. If you do
>>> not agree to it, please change
>>> appropriate documentation.
>>
>> I think we're talking about two different things.  One thing is that we
>> shouldn't put any _arbitrary_ interpretation rules into the kernel, which
>> I
>> agree with.  The other one is that if there's a _known_ _broken_ hardware
>> and one possible way of handling it is to add a quirk into the kernel, we
>> should at least consider doing that.
>>
>> In my opinion adding a quirk for a broken hardware is not equivalent to
>> "inferring not available properties using some heuristics or mathematical
>> model", if that's what you're referring to.
>
> No, this is not a clear "bug" and not a clear "fix". Please read my reply to
> Miguel.
>
>>
>> That said, the patch should not change the _default_ code in order to
>> handle
>> the quirky hardware correctly.  IMO, the quirky hardware should be
>> recognized
>
> It will change behaviour of at least Samsung notebooks, for which I
> personally saw the charge_now/full_charge being greater then design_charge.
>>
>> during initialisation, if possible, and later handled in a special way.
>>  If
>> it's not possible to detect the broken hardware reliably, I agree that
>> there's
>> nothing we can do about that in the kernel.
>
> I am still not sure if we have a broken hardware here.

I have no idea about batteries, but jumping from 5950 mAh to 7650 mAh
within one second does not seem non-broken to me. ;)

>
> Regards,
> Alex.
>
