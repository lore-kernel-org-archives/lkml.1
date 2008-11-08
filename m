Return-Path: <linux-kernel-owner+w=401wt.eu-S1752965AbYKHTLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752965AbYKHTLL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 14:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751544AbYKHTK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 14:10:57 -0500
Received: from ik-out-1112.google.com ([66.249.90.177]:12864 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbYKHTKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 14:10:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=DcjK7aJdFtDSPqzXEE1/GikcPNny/It7CiqYkRL5+JYZmq2/0UhvSsEY/qMZrdqO3t
         N5JmzZ10mm+wdFUjxdcmaQfEpzUyN6+iAjTQVL6mK7YozDWQcm9cOLcLKkxmpGY15V5u
         wxap4NuryaNeCFzhljDY2G3lSzbcK1d65SURs=
Message-ID: <4915E43E.4010206@gmail.com>
Date: Sat, 08 Nov 2008 20:10:54 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Grant Grundler <grundler@parisc-linux.org>
CC: Nobin Mathew <nobin.mathew@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Robert Hancock <hancockr@shaw.ca>
Subject: Re: sharing interrupt between PCI device
References: <fa.h7+lofM1lpbRM5V4/ti5d7RwXuM@ifi.uio.no> <4910E8AC.7050407@shaw.ca> <8d6898730811042349p19e65556l8e1c851b27758d5@mail.gmail.com> <20081108172716.GA28039@colo.lackof.org>
In-Reply-To: <20081108172716.GA28039@colo.lackof.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler napsal(a):
> So I see how the IRQ is enabled and disabled. I still don't see where
> an interrupt handler is bound to IRQ 225 (output you posted today in
> another email).

This irq setup is done during pci_enable_device.

> Nobin, can you dump /proc/interrupts when both drivers
> are loaded and also send the dmesg output after both are loaded?

This won't show the hp driver as it doesn't request_irq.
