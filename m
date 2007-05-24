Return-Path: <linux-kernel-owner+w=401wt.eu-S1751114AbXEXPn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbXEXPn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 11:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbXEXPnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 11:43:50 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696AbXEXPnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 11:43:50 -0400
Date: Thu, 24 May 2007 08:42:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jgarzik@pobox.com>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Olivier Galibert <galibert@pobox.com>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-Reply-To: <46552E2E.5000404@pobox.com>
Message-ID: <alpine.LFD.0.98.0705240839520.26602@woody.linux-foundation.org>
References: <4635510D.4060103@shaw.ca> <20070523222443.GA39776@dspnet.fr.eu.org>
 <alpine.LFD.0.98.0705231536510.3890@woody.linux-foundation.org>
 <200705231555.07683.jbarnes@virtuousgeek.org>
 <alpine.LFD.0.98.0705231709220.3890@woody.linux-foundation.org>
 <46552E2E.5000404@pobox.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 24 May 2007, Jeff Garzik wrote:
> 
> The latest Intel chipset I have (ICH9) is legacy free:  no serial port and no
> PS/2 ports.  I had to disable the Linux PS2 input drivers completely, just to
> get the thing to boot.

Ahh, that would be a bug. Can you help trying to debug where it locks up?

I'm also surprised, since on the mac mini I have, I already have:

	i8042.c: No controller found.

and it all works beautifully. Of course, it only did that after the 
horrible crud that is "grub" got fixed, because the bootloader used to 
wait forever, but I thought the kernel itself was able to handle a missing 
PS/2 controller fine.

		Linus
