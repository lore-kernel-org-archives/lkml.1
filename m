Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbXLKQyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbXLKQyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 11:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXLKQyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 11:54:44 -0500
Received: from rtr.ca ([76.10.145.34]:3792 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbXLKQyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 11:54:43 -0500
Message-ID: <475EC0D1.8010200@rtr.ca>
Date: Tue, 11 Dec 2007 11:54:41 -0500
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: trash can <thetrashcan@earthlink.net>
Cc: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       ide <linux-ide@vger.kernel.org>
Subject: Re: Iomega ZIP-100 drive unsupported with jmicron JMB361 chip?
References: <fa.yONLBG7CMuz80f4dUP5r/5k7emw@ifi.uio.no> <475DD7FF.4030906@shaw.ca> <475EAEDD.9090905@earthlink.net>
In-Reply-To: <475EAEDD.9090905@earthlink.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trash can wrote:
..
> Robert Hancock wrote:
>> That is rather curious. There's no sign of any libata error handling
>> going on.. Maybe the drive is actually returning that error code in the
>> ATAPI CDB, or at least we think it is?
>>
>> You are sure that this drive still works with older kernels using
>> drivers/ide, and that the hardware didn't break at some point, I assume?
>>
> Thanks for your time. I get a kernel panic with the controller mode in BIOS
> set to AHCI with Fedora Core 6. Once returned to IDE (setting used since
> computer was built) I booted up. Added information: In Fedora 7 I can not
> burn DVDs or CDROM using K3b with the Zip drive connected. Some
> preformatting (I assume) is done rendering the CD/DVD useless then got an
> I/O error. In Fedora 8 I am able to burn a CDROM using K3b but DVDs behave
> as with Fedora 7. All is well when the Zip is totaly removed. This Zip
> drive also worked under Microsoft 2000 { which was removed over a year
> ago ;-) }. Fedora Core 6, Fedora 7, and Fedora 8 are all installed on
> this machine. This drive did not work with a Ubuntu 7.10 Live CD on this
> machine. I intend to try this Zip drive on another motherboard with the
> above live CD.
...

I missed the early part of this thread,
but here is a data point that may or may not be useful.

I have an ASUS mobo here with an onboard JM363 SATA/PATA controller
(verified by looking at the actual chip).

It works fine when in AHCI mode with a PATA ATAPI ZIP100 drive
all by itself.  No other configurations tested.
This is with kernel 2.6.24-rc4-git?.

Cheers
