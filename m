Return-Path: <linux-kernel-owner+w=401wt.eu-S1758506AbYAUXtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758506AbYAUXtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:49:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbYAUXto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:49:44 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:63485 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324AbYAUXto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:49:44 -0500
Date: Mon, 21 Jan 2008 17:49:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: PCI Interrupt Problems Since Kernel-2.6.19
In-reply-to: <fa.ymyLoSJzoVBOIvut+kIrLt7x/M4@ifi.uio.no>
To: Lost Garden <yuanzhiqiang13@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <47952F7B.7080506@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.ymyLoSJzoVBOIvut+kIrLt7x/M4@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lost Garden wrote:
>     I'm writing a driver for DVB-C PCI receiving cards these days and
> I found a tricky problem of interrupts. Since kernel-2.6.19 the
> interrupt handlers get rid of "struct pt_regs*" argument  and I think
> it will be easy for me to modify the driver to fit for the recent
> kernel.
>    I simply delete the "struct pt_regs *" argument of my interrupt
> handler and compile the driver again. But then I met a rather tricky
> problem. I cann't get the PCI intterrupt now! I found that the chip on
> the card actually had generate an interrupt and it should not be the
> hardware problem.
>   I'm get seriously confused. My driver works well under kernel-2.6.18
> but not generates a single interrupt signal when works above
> kernel-2.6.19.
>  Does anybody meet similar problems?
>  Sincerely
>  Yours, Lost Graden.
> 1,21. 2008

Need more details, like dmesg output. The source code of your driver 
would also be useful. One common problem is not calling 
pci_enable_device before requesting the interrupt..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

