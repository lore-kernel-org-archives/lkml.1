Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYKEIg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYKEIg3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 03:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbYKEIgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 03:36:19 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:51635 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYKEIgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 03:36:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=hFlZy2317t4wfrRHW13sfyyIaxgh0X8t2gWyf1k+0ryjv26AXJxnN8Rk3rvPptistm
         ET1Igaco+VBAd0Nh8gzNG0pcNOorsAQTyqfbiR8iiLTveF6QieaUgES9pIHmmuIZIt26
         BxFWmytqGPDHHidR3nMmveCZiUagVLSpRUV0w=
Message-ID: <49115AFC.2030400@gmail.com>
Date: Wed, 05 Nov 2008 09:36:12 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Nobin Mathew <nobin.mathew@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>
Subject: Re: sharing interrupt between PCI device
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no>	 <4910E8AC.7050407@shaw.ca> <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com>
In-Reply-To: <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2008 08:49 AM, Nobin Mathew wrote:
> Hi
> 
> This is the system information X86_64 platform Xeon dual core processor.
> 
> I saw the pci_disable_device () it is calling pcibios_disable_device
> () and this is is defined as
> 
> void pcibios_disable_device (struct pci_dev *dev)
> {
>         pcibios_disable_resources(dev);
>         if (pcibios_disable_irq)
>                 pcibios_disable_irq(dev);
> }
> 
> In i386 platform, I could not find a definition for these calls in
> x86_64 platform, i think it is using i386 platform code.

Well, will you show us the code, so that we needn't to crystal gaze? It's pretty
hard to say what happens, if we don't see what you do in the driver...
