Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbYJ0PLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbYJ0PLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYJ0PLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:11:14 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:19186 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYJ0PLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=dPE/TKESwlcV9fcOLL8z3Cal84hZqn2uqHyCIFQz5+ivgsLbabaM36TYbHnoqjV0LQ
         geyLqA+5miwExyVQUoHhkd1aE1EzYAqoiEpEfygrP6q4M8UtTP4SkPGiX/RvgoCWLke/
         2q3qjSjdcMWua2moRKycF/mNmWNdbKwWmH8W0=
Message-ID: <4905DA48.2070409@tuffmail.co.uk>
Date: Mon, 27 Oct 2008 15:12:08 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: dri-devel@lists.sourceforge.net
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc1: [drm:i915] *ERROR* ... Disabling tiling
References: <4905CFC3.1060907@tuffmail.co.uk> <4905D750.7000006@tuffmail.co.uk>
In-Reply-To: <4905D750.7000006@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Alan Jenkins wrote:
>> What does this mean, should I do anything about it?  Is tiling nice 
>> to have?
>>
>> It sounds like GEM broke something - though maybe it just added a 
>> more verbose error report.
>>
>> System: EeePC 701
>> Kernel: v2.6.36-rc1-5-g23cf24c
>> Chipset: Intel mobile 915G-something
>> Regretably necessary kernel boot option: noapic
>>
>>
>> [    1.438441] Linux agpgart interface v0.103
>> [    1.438441] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
>> [    1.438441] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
>> [    1.443353] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 
>> 0xd0000000
>> [    1.443353] [drm] Initialized drm 1.1.0 20060810
>> [    1.443353] pci 0000:00:02.0: PCI INT A -> Link[LNKA] -> GSI 5 
>> (level, low) -> IRQ 5
>> [    1.443353] pci 0000:00:02.0: setting latency timer to 64
>> [    1.443353] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't 
>> read from MCHBAR.  Disabling
>> tiling.

There's no obvious difference in Xorg.log (compared to 2.6.27).  In fact 
it claims to have successfuly enabled tiling.

(**) intel(0): Tiling enabled
(II) intel(0): Attempting memory allocation with tiled buffers.
(II) intel(0): Success.

So these new kernel error messages seem a bit random.

Thanks
Alan
