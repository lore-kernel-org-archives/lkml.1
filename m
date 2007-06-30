Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbXF3WxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbXF3WxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 18:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbXF3WxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 18:53:13 -0400
Received: from bizon.gios.gov.pl ([212.244.124.8]:60519 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbXF3WxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 18:53:13 -0400
Date: Sun, 1 Jul 2007 00:53:01 +0200 (CEST)
From: Krzysztof Oledzki <olel@ans.pl>
X-X-Sender: olel@bizon.gios.gov.pl
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: IRQ handling difference between i386 and x86_64
In-Reply-To: <1183218035.2894.13.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0707010045040.9268@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0706301617240.16011@bizon.gios.gov.pl>
 <1183218035.2894.13.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1501710822-1183243981=:9268"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1501710822-1183243981=:9268
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 30 Jun 2007, Arjan van de Ven wrote:

> On Sat, 2007-06-30 at 16:55 +0200, Krzysztof Oledzki wrote:
>> Hello,
>>
>> It seems that IRQ handling is somehow different between i386 and x86_64.
>>
>> In my Dell PowerEdge 1950 is it possible to enable interrupts spreading
>> over all CPUs. This a single CPU, four CORE system (Quad-Core E5335 Xeon=
)
>> so I think that interrupts migration may be useful. Unfortunately, it
>> works only with 32-bit kernel. Booting it with x86_64 leads to situation=
,
>> when all interrupts goes only to the first cpu matching a smp_affinity
>> mask.
>
> arguably that is the most efficient behavior... round robin of
> interrupts is the worst possible case in terms of performance

Even on dual/quadro core CPUs with shared cache? So why it is possible to=
=20
enable such behaviuor in BIOS, which works only on i386 BTW. :(

> are you using irqbalance ? (www.irqbalance.org)

Yes, I'm aware about this useful tool, but in some situations (routing=20
for example) it cannot help much as it keeps three cpus idle. :(

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1501710822-1183243981=:9268--
