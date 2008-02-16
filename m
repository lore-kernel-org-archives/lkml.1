Return-Path: <linux-kernel-owner+w=401wt.eu-S1759049AbYBPQrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759049AbYBPQrJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 11:47:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757137AbYBPQqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 11:46:53 -0500
Received: from an-out-0708.google.com ([209.85.132.240]:36959 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345AbYBPQqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 11:46:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=DcPaDSO6us1rLpFeFabsASN1zg5WCSrSwAfTjuN17zxmOxdpkWz089q0V53v0afoDVPtO7kMyRE+/qHudV6m2YiJpqr5TMsC3MlLD1uHv6/Fc65ZQxs5ZasQDd44IZu0QMmS/p1RFfuSjg5tncktKTOc4e6f/G+TqKtKa8arZVc=
Message-ID: <47B71372.5050804@gmail.com>
Date: Sat, 16 Feb 2008 11:46:42 -0500
From: Andrew Buehler <abuehler.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB regression (and other failures) in 2.6.2[45]*
References: <Pine.LNX.4.44L0.0802161013190.3769-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0802161013190.3769-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Note: I consider it blatantly incorrect to send a reply both to a
mailing list and directly to the address of someone who is subscribed to
that list unless you have reason to believe that that someone will not
see the message otherwise, but in this case I am doing so anyway because
I see no way to avoid it and still make sure all relevant people receive
the message.)

On 2/16/2008 10:20 AM, Alan Stern wrote:

> On Sat, 16 Feb 2008, Oliver Pinter wrote:
> 
>> On 2/15/08, Andrew Buehler <abuehler.kernel@gmail.com> wrote:
>>> In my workplace, I use a customized version of Novell's ZENworks
>>> imaging boot CD, which is based off of Linux. I have one
>>> particular model of laptop - the IBM/Lenovo R61 - on which three
>>> different things fail completely in current kernels (tested with
>>> 2.6.24.2 and 2.6.25-rc1): USB, AHCI (and thus access to the SATA
>>> drive), and networking. As a consequence of all three failing in
>>> parallel, I have no practical way to get logs and other
>>> information off of the machine to help with tracking down the
>>> bugs.
> 
> ...
> 
> To make a long story short, the USB symptoms you describe indicate a
> problem with interrupt routing.  This could well explain the other
> difficulties too.  There are various kernel parameters you can try
> putting on the boot command line to work around it:  acpi=noirq or
> acpi=off or pci=noacpi or a few others.

I have now tried all three of these, with no apparent effect; the USB
drive is still not detected when plugged in after boot. A naive search
on Google provides no indication of other possible parameters to try;
the only list I have found of ACPI-related kernel parameters includes no
others which seem likely to be helpful without more knowledge of the
specifics of the situation (and the subsystem) than I have.

What would the next step be?

-- 
    Andrew Buehler
