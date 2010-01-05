Return-Path: <linux-kernel-owner+w=401wt.eu-S1753539Ab0AEHK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab0AEHK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 02:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910Ab0AEHK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 02:10:57 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:37774 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab0AEHK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 02:10:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=MC8xrDNWDiKGCVhXyublJTB78hkEtGwDPkk/VlJ09GN7sZzZopu7X5N61FNbdE/w59
         0SrO7phIkPQLAFdFHKnCMRDoCyuLPt9jTLsZPbbAhUSGEeazi73+l9Z64N2ryczR2yQr
         +VX9gE/cseFgXKAW9KZ7K2YsCsmBVV0DpmSU8=
MIME-Version: 1.0
Reply-To: jarod@wilsonet.com
In-Reply-To: <80A6ED01A151614884EE6C5D6AF0F2E90460683B6A@SJEXCHCCR01.corp.ad.broadcom.com>
References: <80A6ED01A151614884EE6C5D6AF0F2E90460683B6A@SJEXCHCCR01.corp.ad.broadcom.com>
Date: Tue, 5 Jan 2010 02:10:56 -0500
Message-ID: <7cdf10991001042310n2d750e0o3fddb047bf762871@mail.gmail.com>
Subject: Re: [PATCH v3] staging: add Broadcom Crystal HD driver
From: Jarod Wilson <jarodwilson@gmail.com>
To: "Naren (Narendra) Sankar" <nsankar@broadcom.com>
Cc: "hancockrwd@gmail.com" <hancockrwd@gmail.com>,
       "jarod@redhat.com" <jarod@redhat.com>,
       "greg@kroah.com" <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "davilla@4pi.com" <davilla@4pi.com>,
       "abraham.manu@gmail.com" <abraham.manu@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, cool. Greg, would you like an updated trimmed header before
adding this to staging, or can I just follow up later with a patch to
reduce the heft?

--jarod


On Tue, Jan 5, 2010 at 2:05 AM, Naren (Narendra) Sankar
<nsankar@broadcom.com> wrote:
> That is ok by us.
>
> The driver does only use a small subset.
>
> Naren
>
> ----- Original Message -----
> From: Jarod Wilson <jarodwilson@gmail.com>
> To: Naren (Narendra) Sankar
> Cc: Robert Hancock <hancockrwd@gmail.com>; Jarod Wilson <jarod@redhat.com>; Greg KH <greg@kroah.com>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; Scott Davilla <davilla@4pi.com>; Manu Abraham <abraham.manu@gmail.com>
> Sent: Mon Jan 04 22:58:29 2010
> Subject: Re: [PATCH v3] staging: add Broadcom Crystal HD driver
>
> On Mon, Jan 4, 2010 at 9:36 PM, Naren (Narendra) Sankar
> <nsankar@broadcom.com> wrote:
>> The register bits come straight from the HW RTL. So this way there are no errors or typos. It would be easier for maintenance from our side since this is generated automagically. And when we add new HW, again it is a script that spews this out.
>>
>> Not absolutely necessary, but worried that cleanups may cause more problems than fix.
>
> I think the automation is worth it to a point, but this header does
> seem to be a wee bit excessive. I doubt if we're even using 1% of the
> ~12k defines in that one header, so we're bloating the code by a huge
> amount for relatively little benefit. Its probably worth maintaining
> the full register header *somewhere* (in with the userspace lib
> somewhere?), but maybe we just do a trimmed down version for the
> kernel module that contains only the bits we actually need.
>
>> -----Original Message-----
>> From: Robert Hancock [mailto:hancockrwd@gmail.com]
>> Sent: Monday, January 04, 2010 6:22 PM
>> To: Jarod Wilson
>> Cc: Greg KH; linux-kernel@vger.kernel.org; Scott Davilla; Naren (Narendra) Sankar; Manu Abraham
>> Subject: Re: [PATCH v3] staging: add Broadcom Crystal HD driver
>>
>> On 01/04/2010 05:34 PM, Jarod Wilson wrote:
>>> On 1/4/10 6:19 PM, Greg KH wrote:
>>>> On Mon, Jan 04, 2010 at 06:02:27PM -0500, Jarod Wilson wrote:
>>>>> This patch supersedes the earlier ones sent by Manu Abraham to add
>>>>> the Broadcom Crystal HD driver to the staging tree, per discussion
>>>>> with him about it. I've been working with Broadcom's Naren Sankar
>>>>> on this driver for a number of months, and had already talked Naren
>>>>> about submitting this on Broadcom's behalf, didn't expect anyone
>>>>> else to jump on submitting it as quickly as Manu did. ;)
>>>>
>>>> Looks good, I'll queue it up tomorrow.
>>>
>>> Nb: it looks like the thing is so massive (~935k), its not showing up on
>>> lkml (at least, not in a timely fashion), so for the interested:
>>>
>>> <http://people.redhat.com/jwilson/misc/broadcom-crystalhd-decoder-driver-staging.patch>
>>>
>>> Thanks much!
>>
>> Literally the majority of the code is #defines for what looks like
>> register bits, etc - is all that really necessary?
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>
>
> --
> Jarod Wilson
> jarodwilson@gmail.com
>
>



-- 
Jarod Wilson
jarodwilson@gmail.com
