Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450Ab0AEHFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab0AEHFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 02:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768Ab0AEHFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 02:05:48 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2132 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab0AEHFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 02:05:47 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Naren (Narendra) Sankar" <nsankar@broadcom.com>
To: "'jarod@wilsonet.com'" <jarod@wilsonet.com>
cc: "'hancockrwd@gmail.com'" <hancockrwd@gmail.com>,
       "'jarod@redhat.com'" <jarod@redhat.com>,
       "'greg@kroah.com'" <greg@kroah.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'davilla@4pi.com'" <davilla@4pi.com>,
       "'abraham.manu@gmail.com'" <abraham.manu@gmail.com>
Date: Mon, 4 Jan 2010 23:05:36 -0800
Subject: Re: [PATCH v3] staging: add Broadcom Crystal HD driver
Thread-Topic: [PATCH v3] staging: add Broadcom Crystal HD driver
Thread-Index: AcqN1ISpz1AAK12oT0e4qGBkiPWl7QAAPY6t
Message-ID: <80A6ED01A151614884EE6C5D6AF0F2E90460683B6A@SJEXCHCCR01.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 675C3B4A3J860499831-01-01
Content-Type: text/plain;
 charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o0576Q16004347

That is ok by us. 

The driver does only use a small subset. 

Naren

----- Original Message -----
From: Jarod Wilson <jarodwilson@gmail.com>
To: Naren (Narendra) Sankar
Cc: Robert Hancock <hancockrwd@gmail.com>; Jarod Wilson <jarod@redhat.com>; Greg KH <greg@kroah.com>; linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; Scott Davilla <davilla@4pi.com>; Manu Abraham <abraham.manu@gmail.com>
Sent: Mon Jan 04 22:58:29 2010Subject: Re: [PATCH v3] staging: add Broadcom Crystal HD driver

On Mon, Jan 4, 2010 at 9:36 PM, Naren (Narendra) Sankar
<nsankar@broadcom.com> wrote:
> The register bits come straight from the HW RTL. So this way there are no errors or typos. It would be easier for maintenance from our side since this is generated automagically. And when we add new HW, again it is a script that spews this out.
>
> Not absolutely necessary, but worried that cleanups may cause more problems than fix.

I think the automation is worth it to a point, but this header does
seem to be a wee bit excessive. I doubt if we're even using 1% of the
~12k defines in that one header, so we're bloating the code by a huge
amount for relatively little benefit. Its probably worth maintaining
the full register header *somewhere* (in with the userspace lib
somewhere?), but maybe we just do a trimmed down version for the
kernel module that contains only the bits we actually need.

> -----Original Message-----
> From: Robert Hancock [mailto:hancockrwd@gmail.com]
> Sent: Monday, January 04, 2010 6:22 PM
> To: Jarod Wilson
> Cc: Greg KH; linux-kernel@vger.kernel.org; Scott Davilla; Naren (Narendra) Sankar; Manu Abraham
> Subject: Re: [PATCH v3] staging: add Broadcom Crystal HD driver
>
> On 01/04/2010 05:34 PM, Jarod Wilson wrote:
>> On 1/4/10 6:19 PM, Greg KH wrote:
>>> On Mon, Jan 04, 2010 at 06:02:27PM -0500, Jarod Wilson wrote:
>>>> This patch supersedes the earlier ones sent by Manu Abraham to add
>>>> the Broadcom Crystal HD driver to the staging tree, per discussion
>>>> with him about it. I've been working with Broadcom's Naren Sankar
>>>> on this driver for a number of months, and had already talked Naren
>>>> about submitting this on Broadcom's behalf, didn't expect anyone
>>>> else to jump on submitting it as quickly as Manu did. ;)
>>>
>>> Looks good, I'll queue it up tomorrow.
>>
>> Nb: it looks like the thing is so massive (~935k), its not showing up on
>> lkml (at least, not in a timely fashion), so for the interested:
>>
>> <http://people.redhat.com/jwilson/misc/broadcom-crystalhd-decoder-driver-staging.patch>
>>
>> Thanks much!
>
> Literally the majority of the code is #defines for what looks like
> register bits, etc - is all that really necessary?
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at Â http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at Â http://www.tux.org/lkml/
>



-- 
Jarod Wilson
jarodwilson@gmail.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
