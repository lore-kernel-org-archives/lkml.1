Return-Path: <linux-kernel-owner+w=401wt.eu-S1760362AbZEABvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760362AbZEABvp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 21:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757938AbZEABvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 21:51:35 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:31252 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbZEABve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 21:51:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=IKr7SdM4lJRZ4mV8EPSN8rScEVlTcgvBYRaB+nVDwKHPeTVjz8ZicfLj2W0y8LumKA
         dok7xNOLsazDsPbzs1MQpC574HcUSNvgSr6w0Mguw17OT8abdh/GOPKa6YyyEMM2PYzs
         nB3EKNffEE0xW9QWYOMUpg+gTpmZmNSvPQPwc=
Message-ID: <49FA55A0.8080303@gmail.com>
Date: Thu, 30 Apr 2009 19:51:28 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Alex Buell <alex.buell@munted.org.uk>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <willy@linux.intel.com>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller
   question)
References: <E1LzLgA-0004j6-9W@closure.thunk.org> <49F90CA2.4080602@garzik.org> <20090430083309.437f9248@lithium.local.net> <20090430113445.GA4809@mit.edu> <20090430113814.GB4809@mit.edu>
In-Reply-To: <20090430113814.GB4809@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Thu, Apr 30, 2009 at 07:34:45AM -0400, Theodore Tso wrote:
>> On Thu, Apr 30, 2009 at 08:33:09AM +0100, Alex Buell wrote:
>>> On Wed, 29 Apr 2009 22:27:46 -0400, I waved a wand and this message
>>> magically appears in front of Jeff Garzik:
>>>
>>>> As Tejun noted, try switching to AHCI mode in BIOS.
>>> But is there a way to switch modes without needing to go through the
>>> BIOS? Some laptops won't let you do that through BIOS. 
>> The BIOS setting already is in AHCI mode, and not in "compatibility
>> mode".  
> 
> Thinking about this a bit more, I'll bet the problem is the BIOS
> setting is only affecting the primary SATA ports (which are being
> grabed by ahci) and not the SATA port in the Ultrabay slot (which is
> being picked up by either the ata_piix or piix driver).  Sigh...

dmesg and lspci -vv output might be useful..
