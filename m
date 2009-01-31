Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbZAaOv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbZAaOv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 09:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZAaOvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 09:51:49 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:43368 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbZAaOvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 09:51:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=oGv41kAYCW4BQeUCXZUXPyqBs2VFDeEOqeqUA+R7wN6+Z40q9C7c2T3yeHgHT/U/A/
         VL4F0rnJP387IbfVi53AUCcgUAhvCOoO0XC4VmnJubuiIyCqPQ/wKQ43mg/FzxVHhUk5
         F23+y9YC4GE+Wf3/RX/lXsmsXyzYNSx8jPjxQ=
MIME-Version: 1.0
In-Reply-To: <6bd94bae0901310604u6ed876f1n77b7e2561f479ad1@mail.gmail.com>
References: <6bd94bae0901310536l2cd42fa1off60ee066fa0096b@mail.gmail.com>
	 <20090131134651.GC28763@khazad-dum.debian.net>
	 <6bd94bae0901310604u6ed876f1n77b7e2561f479ad1@mail.gmail.com>
Date: Sat, 31 Jan 2009 15:51:46 +0100
Message-ID: <6bd94bae0901310651k6a85e2a8g280308da272bdaf7@mail.gmail.com>
Subject: Spurious Filesystem corruption with ext3 + large (<400GB) hw RAID 
	partition + SMP
From: Manfred Wassmann <tux.wassmann@googlemail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 31, 2009 at 2:46 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Sat, 31 Jan 2009, Manfred Wassmann wrote:
>> I'm experiencing spurious filesystem corruption problems with ext3 on
>> a partition larger than 400 GB on a hardware SATA RAID.
>
> Please describe the SATA RAID hardware in a bit more detail.  Which
> SATA controller does it use?

It is a 3ware 9650SE initially supplied with a firmware version FE9X
3.08.00.029 but the problem remained after an upgrade to the current
version 4.06.00.004

> Also, have you made sure it is not caused by bad memory?

I didn't think it could be the memory because the problem occurs with
the 32bit kernel alone but what do you suggest? I only have remote
access to the system over the weekend.

-- 
Unix "Birthday" on 2009-02-13 23:31:30 UTC
...it's 1234567890 seconds since the epoch.
