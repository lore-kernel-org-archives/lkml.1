Return-Path: <linux-kernel-owner+w=401wt.eu-S1161077AbXBOTmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161077AbXBOTmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161074AbXBOTmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:42:50 -0500
Received: from uslec-66-255-149-99.cust.uslec.net ([66.255.149.99]:2318 "EHLO
	mail.wegener.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161075AbXBOTmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:42:50 -0500
Message-ID: <45D4BB12.1050205@wegener.com>
Date: Thu, 15 Feb 2007 14:57:06 -0500
From: Mike Panetta <m.panetta@wegener.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: APIC priorities, can they be changed?
References: <45D4A692.7090108@wegener.com> <fc.3b9aca006fe2a09c3b9aca00cb2296f3.fc598b@wegener.com>
In-Reply-To: <fc.3b9aca006fe2a09c3b9aca00cb2296f3.fc598b@wegener.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux-os (Dick Johnson) wrote:
>
> On Thu, 15 Feb 2007, Mike Panetta wrote:
>
> > I am not on the list (corperate email sucks) so please CC any replies to
> > me.  Thanks.
[snip]
> > I have seen the preempt patches, but they touch a lot of files, and we
> > have gone through testing with the 2.6.16.19 kernel and do not wish to
> > change, and we cannot find a version of the patch for this kernel. Is
> > there something smaller/simpler I can do?  My understanding is the
> > priority in the APIC is set in software via the interrupt vector number
> > (higher numbers have lower priority) is this true?  If so, how hard
> > would it be for me to just change the vector numbers around?
> >
[snip]
> > Thanks,
> > Mike
>
> Can't you muck with the BIOS settings? That's where the primary
> hardware gets 'connected'.
>

I did try that.  The BIOS only allows me to either allocate an IRQ to be 
a PCI interrupt, or reserve it (for what I have no idea).  The IRQ's 
listed in the BIOS are also different from the ones Linux sees.  I think 
the BIOS is seeing the XT-PIC IRQ numbers and Linux is seeing the APIC 
numbers.  For example the little bios blurb that prints before the 
system boots says the USB controller I am interested in is 
assigned/using IRQ 10, Linux sees it using IRQ 18.

I have found that I can keep Linux from using the APIC by disabling it 
with a kernel command line switch, but that does not help, it just makes 
Linux use the XT-PIC instead of the IO-APIC to do IRQ routing.

So I guess I'm back to my original question of  'Would changing the 
vector numbers do what I want?' and if the answer is 'yes', how would I 
do it?

Thanks,
Mike

>
> Cheers,
> Dick Johnson
> Penguin : Linux version 2.6.16.24 on an i686 machine (5592.61 BogoMips).
> New book: http://www.AbominableFirebug.com/
> _
> 
>
> ****************************************************************
> The information transmitted in this message is confidential and may be 
> privileged.  Any review, retransmission, dissemination, or other use 
> of this information by persons or entities other than the intended 
> recipient is prohibited.  If you are not the intended recipient, 
> please notify Analogic Corporation immediately - by replying to this 
> message or by sending an email to DeliveryErrors@analogic.com 
> <mailto:DeliveryErrors@analogic.com> - and destroy all copies of this 
> information, including any attachments, without reading or disclosing 
> them.
>
> Thank you.
>

