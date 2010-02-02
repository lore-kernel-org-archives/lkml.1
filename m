Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0BBQpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 11:45:07 -0500
Received: from smtp-out.google.com ([216.239.33.17]:44524 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab0BBQpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 11:45:00 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=btVEb5UuYaAfyDjbpSfSiGo+CUVU+rpa5rfJwHaDBZwKq/XjEZ+DSZqDZOGBiBnaf
	R1AtwSjjTvyi6Cebixwsw==
MIME-Version: 1.0
In-Reply-To: <4B683DEF.3000302@gmail.com>
References: <4B5885F7.2020007@gmail.com> <4B679EA9.6030203@kernel.org>
	 <4B6833DD.1020001@gmail.com> <4B683581.7070708@kernel.org>
	 <4B683DEF.3000302@gmail.com>
Date: Tue, 2 Feb 2010 08:44:50 -0800
Message-ID: <da824cf31002020844r12cada26x57f96b0aa24b59c6@mail.gmail.com>
Subject: Re: port multiplier problem
From: Grant Grundler <grundler@google.com>
To: Chandra Shekhar Sah <edu4madh@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 2, 2010 at 6:59 AM, Chandra Shekhar Sah <edu4madh@gmail.com> wrote:
> Hi Tejun,
>
> I have attached full dmesg output, while 9 disks are connected to PMP, and
> no disk to "direct sata".

Linux version 2.6.31.12-174.2.3.fc12.i686.PAE
(mockbuild@x86-04.phx2.fedoraproject.org)
...
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
ata3.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
ata3.00: hard resetting link
ata3.00: SATA link down (SStatus 0 SControl 10)
ata3.01: hard resetting link
ata3.01: SATA link down (SStatus 0 SControl 320)
ata3.02: hard resetting link
ata3.02: SATA link down (SStatus 0 SControl 320)
ata3.03: hard resetting link
ata3.03: SATA link down (SStatus 0 SControl 320)
ata3.04: hard resetting link
ata3.04: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.05: hard resetting link
ata3.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)

Sil3726 has only 5 ports. 6th port is an enclosure management port.
Wasn't there a patch submitted to ignore the enclosure mgt port?

I doubt this is the problem Chandra is seeing but it could be related.

Chandra, just to be complete, can you share which drive model and
firmware is printed on the drive label?

thanks,
grant
