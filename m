Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYKEA2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYKEA2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 19:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYKEA2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 19:28:32 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:7550 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbYKEA2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 19:28:32 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=oq1hYn64rr-WQxyCEAMA:9 a=4B33EmBpWgAI2g2XspMA:7 a=7HiAhuY9_OueTtR3zfc1KMm5IZsA:4 a=w9JcUHXQiIwA:10
Message-ID: <4910E8AC.7050407@shaw.ca>
Date: Tue, 04 Nov 2008 18:28:28 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Nobin Mathew <nobin.mathew@gmail.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sharing interrupt between PCI device
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no>
In-Reply-To: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobin Mathew wrote:
> Hi,
> 
> I think this question is already asked in this mailing list and Sorry
> for asking this again.
> 
> My problem is this:
> 
> I have two PCI devices ( also two kernel drivers for those) which
> shares the interupt. When I remove one driver other device stops
> working, which is happening due to pci_disable_device () in removed
> driver. This call is disabling the shared interrupt.

pci_disable_device shouldn't be disabling the interrupt line, at least 
not in this case. Without more details on the platform or drivers, it's 
difficult to say why this would happen.

> 
> We can avoid this by just removing the pci_disable_device () in the
> driver, but i dont think this is a good way (correct me if I am
> wrong).
> 
> Can you suggest some ways to overcome this issue.

