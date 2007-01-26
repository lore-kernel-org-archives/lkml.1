Return-Path: <linux-kernel-owner+w=401wt.eu-S1030762AbXAZGSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030762AbXAZGSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 01:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030785AbXAZGSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 01:18:50 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:26961 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030762AbXAZGSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 01:18:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RqTk0ph+QlBE6OHaaZ9Mv3/pqyPskzWmfMl1WPrymSv5Hq9k2HF4RiBDmhhwgxBGRWzJZDJBdNCiLYG1az5io+mTLLk8gKNkDhlvKtXNj43ZVoFFwEDtZpcviVLsvICFqjB5S4XKEA87rHnRGrDaBiPExziQKMKBlpooNo7kYtQ=
Message-ID: <a71293c20701252218y326c392ehb7ee5127436d29bd@mail.gmail.com>
Date: Fri, 26 Jan 2007 01:18:47 -0500
From: "Stephen Evanchik" <evanchsa@gmail.com>
To: "Luming Yu" <luming.yu@gmail.com>
Subject: Re: SATA ahci Bug in 2.6.19.x
Cc: "Stefan Priebe - FH" <studium@profihost.com>, linux-kernel@vger.kernel.org
In-Reply-To: <3877989d0701252122s7e5ad92fo5496daf566fd9f97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45B46FA0.2060901@profihost.com>
	 <a71293c20701220600v426f0efdyc23dd945852f71c0@mail.gmail.com>
	 <3877989d0701251925i8bbc09emd8dcad8d098195d2@mail.gmail.com>
	 <a71293c20701252046o73fabcb9v611dedbb6f6b90e3@mail.gmail.com>
	 <3877989d0701252122s7e5ad92fo5496daf566fd9f97@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/26/07, Luming Yu <luming.yu@gmail.com> wrote:
> >
> Is there any difference in dmesg with acpi=off?
> what is your sata driver?

The only difference is that I don't see the "ACPI: PCI Interrupt
0000:00:0f.0[B] -> GSI
21 (level, low) -> IRQ 19" printk. The driver is AHCI but the device
is a VIA chip.

I'll get a caputre of the boot log when I find my serial cable. This
could be related to the VIA PIC quirks that was changed by Alan.

Stephen
