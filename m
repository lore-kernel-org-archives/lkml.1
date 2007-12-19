Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbXLSNVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbXLSNVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 08:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXLSNVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 08:21:09 -0500
Received: from spirit.analogic.com ([204.178.40.4]:4596 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbXLSNVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 08:21:08 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 19 Dec 2007 13:20:31.0904 (UTC) FILETIME=[EE56EA00:01C84241]
Content-class: urn:content-classes:message
Subject: Re: Memory Read Error
Date: Wed, 19 Dec 2007 08:20:31 -0500
Message-ID: <Pine.LNX.4.61.0712190817040.7842@chaos.analogic.com>
in-reply-to: <47685FF9.3070200@shaw.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Memory Read Error
thread-index: AchCQe5is9El0xH+T467UD9k0665SQ==
References: <fa.yTn6oyQbSXQNb3Mbl4UGupJ9LWo@ifi.uio.no> <47685FF9.3070200@shaw.ca>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Cc: "shashi59" <sasikumar.periyasamy@gmail.com>,
       "Linux kernel" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Dec 2007, Robert Hancock wrote:

> shashi59 wrote:
>> I am newbie for Linux Kernel.How can I read the memory area like the range
>> between ffff0000 to ffffffff.Directly i read that area it shows some error
>> like this "unable to handle kernel paging request at virtual address
>> ffff0000". So,I don't know, how to solve this error .Please anyone help
>> me....
>
> First off, why are you trying to do this and how. Without such details
> it's impossible to answer this question.
>
> -- 
> Robert Hancock      Saskatoon, SK, Canada
> To email, remove "nospam" from hancockr@nospamshaw.ca
> Home Page: http://www.roberthancock.com/
>

A possible hint to the newbie, with possibly English as
his last language, check out ioremap() and ioremap_nocache().
Within the kernel, these calls should allow any address
to be read, even if nothing exists at that address.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
