Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbYCUBit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbYCUBit (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 21:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYCUBij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 21:38:39 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:13651 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYCUBii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 21:38:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=lWWtY8Gen9SfDAx1JIz4kHHtj3WTlnCdcOReYWh7Ugf1cba2yos+bkTkHcjoYACi8h1X/z/poLLb9cySOgtd8ZjYYf5PSO3lN9Hk+iIT2Zbmckc8p76gok/LhQIGIp3Oams9skzlqjhm7GD24jzJ5VSxz3nPFEQxAYzz/hMoYRs=
Message-ID: <47E31197.70003@gmail.com>
Date: Fri, 21 Mar 2008 10:38:31 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "Peter F. Patel-Schneider" <pfps@verizon.net>,
       linux-kernel@vger.kernel.org,
       "Peter F. Patel-Schneider" <pfps@research.bell-labs.com>
Subject: Re: 2.6.23-rc9-git4: pata_pcmcia, disabling IRQ #9 and Re: libata
 and legacy ide pcmcia failure
References: <47067DB9.80200@roarinelk.homelinux.net>	<47E300B2.7000104@verizon.net> <20080321011205.4c7b4a61@core>
In-Reply-To: <20080321011205.4c7b4a61@core>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> O> Mar 20 19:51:45 idefix kernel: ata12: PATA max PIO0 cmd 0xa100 ctl 
>> 0xa10e irq 3
>> Mar 20 19:52:15 idefix kernel: ata12.00: qc timeout (cmd 0x91)
>> Mar 20 19:52:15 idefix kernel: ata12.00: failed to IDENTIFY 
>> (INIT_DEV_PARAMS failed, err_mask=0x4)
> 
> Thinkpad T61p .. I've seen a few of these.
> 
> Firstly try the card and adapter in a different PC and let me know if
> that works. So far they do. If that is the case get the latest firmware
> updates (BIOS etc) for your thinkpad and see if the problem goes away.
> They (or our ACPI code I guess it may be) have some serious IRQ routing
> problems on this box.

Any chance the thing just chokes up on INIT_DEV_PARAMS?

-- 
tejun
