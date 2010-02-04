Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab0BDDOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:14:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:45569 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab0BDDOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:14:32 -0500
Message-ID: <4B6A3D24.8020802@kernel.org>
Date: Thu, 04 Feb 2010 12:21:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
CC: Chandra Shekhar Sah <edu4madh@gmail.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: port multiplier problem
References: <4B5885F7.2020007@gmail.com> <4B679EA9.6030203@kernel.org>	 <4B6833DD.1020001@gmail.com> <4B683581.7070708@kernel.org>	 <4B683DEF.3000302@gmail.com> <da824cf31002020844r12cada26x57f96b0aa24b59c6@mail.gmail.com>
In-Reply-To: <da824cf31002020844r12cada26x57f96b0aa24b59c6@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 03:14:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/03/2010 01:44 AM, Grant Grundler wrote:
> On Tue, Feb 2, 2010 at 6:59 AM, Chandra Shekhar Sah <edu4madh@gmail.com> wrote:
>> Hi Tejun,
>>
>> I have attached full dmesg output, while 9 disks are connected to PMP, and
>> no disk to "direct sata".
> 
> Linux version 2.6.31.12-174.2.3.fc12.i686.PAE
> (mockbuild@x86-04.phx2.fedoraproject.org)
> ...
> ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> ata3.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
> ata3.00: hard resetting link
> ata3.00: SATA link down (SStatus 0 SControl 10)
> ata3.01: hard resetting link
> ata3.01: SATA link down (SStatus 0 SControl 320)
> ata3.02: hard resetting link
> ata3.02: SATA link down (SStatus 0 SControl 320)
> ata3.03: hard resetting link
> ata3.03: SATA link down (SStatus 0 SControl 320)
> ata3.04: hard resetting link
> ata3.04: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata3.05: hard resetting link
> ata3.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
> 
> Sil3726 has only 5 ports. 6th port is an enclosure management port.
> Wasn't there a patch submitted to ignore the enclosure mgt port?

Eh... I don't think it got included.

> I doubt this is the problem Chandra is seeing but it could be related.

Doesn't seem to be.  IDENTIFY failures are coming from normal ports.

Thanks.

-- 
tejun
