Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbYGDQXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbYGDQXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbYGDQXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:23:34 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:13924 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbYGDQXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:23:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=M7rPNeDTNe4YY/uoQRKKaBLqmg7ZqKblJgUd08Qy7+enZomWRSMbZ71b3CY9tYwb1T
         lIU6WBG2IPPwsx8P1/YfpS1YIo3AeSqcfJal+BusvTltd6C8zHjR3Cq+AkEihDkOskZ6
         VhIuT757SSJrVb01i9ZabYa/GR/J2A4ydwJCk=
Message-ID: <dd18b0c30807040923v37e2d8c3id680d76b9cf494bf@mail.gmail.com>
Date: Fri, 4 Jul 2008 16:23:32 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Alexey Starikovskiy" <aystarik@gmail.com>
Subject: Re: dsdt buggy acpi
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>
In-Reply-To: <486E0A64.5020903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806302339q7b3effybf8a7f619b009262@mail.gmail.com>
	 <dd18b0c30807010918p48cfbe2bnb7e4a2bf00a01638@mail.gmail.com>
	 <20080702082555.0959ef2b@linux360.ro>
	 <20080702100935.GA699@srcf.ucam.org>
	 <20080702144820.29f7d43d@linux360.ro>
	 <20080702115527.GA3396@srcf.ucam.org>
	 <dd18b0c30807020930u43405fd5v2e328b6b76b833b0@mail.gmail.com>
	 <20080702163510.GA8912@srcf.ucam.org>
	 <dd18b0c30807021037g3faffa6kd1ef26f888f36d11@mail.gmail.com>
	 <486E0A64.5020903@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2008 at 11:32 AM, Alexey Starikovskiy <aystarik@gmail.com> wrote:
> Justin Mattock wrote:
>>
>> On Wed, Jul 2, 2008 at 4:35 PM, Matthew Garrett <mjg59@srcf.ucam.org>
>> wrote:
>>
>>>
>>> On Wed, Jul 02, 2008 at 04:30:11PM +0000, Justin Mattock wrote:
>>>
>>>
>>>>
>>>> Hello; what info is supplied with EFI i.g. I'm using a macbook pro.
>>>> After looking at:
>>>> http://acpi.sourceforge.net/dsdt/view.php I was unable to locate
>>>> anything with apple, or at least
>>>> couldn't find the manufacture number.
>>>> If somebody has already done this, I was wondering if it would be O.K.
>>>> if I can attached my dsdt.dsl with the errors,
>>>> and my explanation of what I changed, just so If I did something
>>>> completely wrong
>>>>
>>>
>>> iasl will complain about code that the Linux interpreter will happily
>>> accept. If the only reason you've made changes is that iasl complains,
>>> then it's unlikely that there's any functional difference as a result.
>>> Otherwise, work out which changes fix which Linux bugs and file a bug
>>> at bugzilla.kernel.org against acpi.
>>>
>>> --
>>> Matthew Garrett | mjg59@srcf.ucam.org
>>>
>>>
>>
>> Hello; I modified dsdt because iasl was complaining, As a result like
>> what you said
>> "then it's unlikely that there's any functional difference as a
>> result" is probably
>> what I'm seeing. As for a bug report I already have one filed. As to
>> why I'm messing with
>> the dsdt, just trying to isolate the problem with the bug I have
>> already filed., or at least
>> get a better idea of what is happening. Anyways thanks for the info.
>> regards;
>>
>>
>
> For difference, you should look for "Darwin", this is how MacOS X identifies
> itself to hardware.
>
>
> Regards,
> Alex.
>

Hello;
So adding acpi_osi=Darwin will work for boot parameter. Also I wanted
to apologize If I pissed you off,
I didn't quite understand what was really happening, and now after
looking into the scenario, I think I need to find out
what is going on with my GPE's, this way you're detector(ec.c) won't
be going off so frequently.
regards;

-- 
Justin P. Mattock
