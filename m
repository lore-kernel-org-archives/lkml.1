Return-Path: <linux-kernel-owner+w=401wt.eu-S1763891AbXJPMh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763891AbXJPMh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 08:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbXJPMhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 08:37:17 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:3536 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757337AbXJPMhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 08:37:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 16 Oct 2007 12:37:12.0682 (UTC) FILETIME=[46A51CA0:01C80FF1]
Content-class: urn:content-classes:message
Subject: Re: halt does not shut the system down
Date: Tue, 16 Oct 2007 08:37:12 -0400
Message-ID: <Pine.LNX.4.61.0710160835160.11232@chaos.analogic.com>
In-reply-to: <4714979C.5010103@free.fr>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: halt does not shut the system down
Thread-Index: AcgP8UauwCP3IrvKS/iEFYpGN8ekaQ==
References: <470A58AF.9080402@free.fr> <470C9731.6030200@free.fr> <470F4535.3050004@free.fr> <470F4F58.4080900@gmail.com> <470F7264.8070205@free.fr> <471342C8.2030305@free.fr> <4714979C.5010103@free.fr>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "John Sigler" <linux.kernel@free.fr>
Cc: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <robert.moore@intel.com>, <len.brown@intel.com>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 16 Oct 2007, John Sigler wrote:

> John Sigler wrote:
>
>> Alexey Starikovskiy wrote:
>>
>>> Could you please open bug at bugzilla.kernel.org and put all these
>>> files there?
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=9148
>>
>> Writing 15361 (i.e. 0x3C01) to ACPI_REGISTER_PM1A_CONTROL appears to
>> hang my system in acpi_os_write_port(). What can I do about that?
>
> Another observation: if I connect a screen to the system's VGA port,
> when I call 'poweroff' the screen goes into power saving mode. This
> seems to indicate that the integrated video card is properly shut down.
>
> So the fans keep spinning, the LEDs keep shining, the LCD keeps
> displaying, but the video card is shut down?
>
> Might this help pinpoint the problem?
>
> Regards.
> -

Check the BIOS to see if the "Power Button" is configured to
shut the system down. Some BIOS configure APM to do what
the power button does!

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.59 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
