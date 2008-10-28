Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746AbYJ1Tk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746AbYJ1Tk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 15:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYJ1TkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 15:40:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:29168 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbYJ1TkT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 15:40:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,500,1220252400"; 
   d="scan'208";a="456423673"
From: "Moore, Robert" <robert.moore@intel.com>
To: Fabio Comolli <fabio.comolli@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Date: Tue, 28 Oct 2008 12:40:16 -0700
Subject: RE: ACPI warning in 2.6.28-rc1
Thread-Topic: ACPI warning in 2.6.28-rc1
Thread-Index: Ack2iAuIzxLZ2KK6TbWl6QmAYbX9qACrLyjw
Message-ID: <4911F71203A09E4D9981D27F9D8308580ADBF12C@orsmsx503.amr.corp.intel.com>
References: <b637ec0b0810241509j43a6bfc9q506dc16a612e7f06@mail.gmail.com>
	 <4911F71203A09E4D9981D27F9D8308580AA800C4@orsmsx503.amr.corp.intel.com>
 <b637ec0b0810250257oc9718f0yb6fc9fc2b53e80fc@mail.gmail.com>
In-Reply-To: <b637ec0b0810250257oc9718f0yb6fc9fc2b53e80fc@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.

The Linux battery driver can in fact handle the buffer where there should be a string, so this warning can be ignored.

The acpidump is very helpful for characterizing the problem, and we are investigating the proper course of action.

Bob


>-----Original Message-----
>From: Fabio Comolli [mailto:fabio.comolli@gmail.com]
>Sent: Saturday, October 25, 2008 2:57 AM
>To: Moore, Robert
>Cc: Linux Kernel Mailing List; ACPI mailing list; Len Brown
>Subject: Re: ACPI warning in 2.6.28-rc1
>
>Here you are.
>Regards,
>Fabio
>
>
>
>On Sat, Oct 25, 2008 at 12:34 AM, Moore, Robert <robert.moore@intel.com>
>wrote:
>> Please send the acpidump for the machine so we can look at the method.
>> Thanks,
>> Bob
>>
>>
>>>-----Original Message-----
>>>From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
>>>owner@vger.kernel.org] On Behalf Of Fabio Comolli
>>>Sent: Friday, October 24, 2008 3:09 PM
>>>To: Linux Kernel Mailing List
>>>Cc: ACPI mailing list; Len Brown
>>>Subject: ACPI warning in 2.6.28-rc1
>>>
>>>Hi all.
>>>As the subject says:
>>>
>>>ACPI Warning (nspredef-0858): \_SB_.PCI0.LPCB.EC0_.BAT0._BIF: Return
>>>Package type mismatch at index 11 - found Buffer, expected String
>>>[20080926]
>>>
>>>No functional problems so far.
>>>--
>>>To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>>>the body of a message to majordomo@vger.kernel.org
>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
