Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbYFKN6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbYFKN6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 09:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750953AbYFKN6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 09:58:09 -0400
Received: from mail-wa4.bigfish.com ([216.32.181.112]:25208 "EHLO
	mail76-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751417AbYFKN6I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 09:58:08 -0400
X-Greylist: delayed 1697 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jun 2008 09:58:08 EDT
X-BigFish: VPS-31(z6f5iz542N1432R7efV1805Mzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-WSS-ID: 0K2AW5H-03-KKC-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/3] AMD Family10h+ IBS support for oProfile driver: Setup routines
Date: Wed, 11 Jun 2008 09:29:29 -0400
Message-ID: <6096959DEF5C9447A6BF80BDC7EB9EDC08650A67@SBOSEXMB1.amd.com>
In-Reply-To: <87abhsp42o.fsf@basil.nowhere.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/3] AMD Family10h+ IBS support for oProfile driver: Setup routines
Thread-Index: AcjLu/f7jm1LrXRlRcOZBQOR8AolpgACxZIg
References: <20080609175030.2844.77365.sendpatchset@localhost.localdomain><20080611105151.GE5612@ucw.cz> <87abhsp42o.fsf@basil.nowhere.org>
From: "Kasindorf, Barry" <Barry.Kasindorf@amd.com>
To: "Andi Kleen" <andi@firstfloor.org>, "Pavel Machek" <pavel@suse.cz>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Jun 2008 13:29:31.0480 (UTC) FILETIME=[2E3DED80:01C8CBC7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes,
This is visible to userspace. The corresponding changes to the usermode
code have been sent to the oProfile list. The confusion is that it is
not AMD Family 10 but it is Family 16(10h). This can be confusing so we
changed it.
-Barry

-----Original Message-----
From: Andi Kleen [mailto:andi@firstfloor.org] 
Sent: Wednesday, June 11, 2008 8:08 AM
To: Pavel Machek
Cc: Kasindorf, Barry; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] AMD Family10h+ IBS support for oProfile driver:
Setup routines

Pavel Machek <pavel@suse.cz> writes:

> Hi!
>
>> This patchset supports the new profiling hardware available in the
latest AMD CPUs in the oProfile driver.
>
>> @@ -419,9 +454,15 @@ int __init op_nmi_init(struct
oprofile_operations *ops)
>>  			break;
>>  		case 0x10:
>>  			model = &op_athlon_spec;
>> -			cpu_type = "x86-64/family10";
>> +			cpu_type = "x86-64/family10h";
>> +			break;
>
> Is this string visible to userspace?

Yes it is.

-Andi


