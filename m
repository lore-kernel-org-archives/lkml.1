Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbYHYH61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbYHYH61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 03:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753491AbYHYH6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 03:58:18 -0400
Received: from mx.bridgeco.net ([213.173.191.47]:2859 "EHLO mx.bridgeco.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbYHYH6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 03:58:17 -0400
From: Wappler Marcel <Marcel.Wappler@bridgeco.net>
To: Arjan van de Ven <arjan@infradead.org>, Ingo Oeser <ioe-lkml@rameria.de>
CC: Alex Riesen <raa.lkml@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 25 Aug 2008 09:58:12 +0200
Subject: RE: Behaviour of the VM on a embedded linux
Thread-Topic: Behaviour of the VM on a embedded linux
Thread-Index: AckGROFeVB6OfXKjSQ+XNqIPVJ/5SgAP/nMg
Message-ID: <462ADBE7F1A69C438B7E2ED56007E6F5ABF7DF982F@exch10.BC-Int.NET>
References: <83116F0A4FF67A4F97BA0B6E408C48E30289D8F0@zuerich.BC-Int.NET>
	<81b0412b0808220559w502edf03y7f318d0f3673884@mail.gmail.com>
	<83116F0A4FF67A4F97BA0B6E408C48E30289D979@zuerich.BC-Int.NET>
	<200808250135.50497.ioe-lkml@rameria.de>
 <20080824165522.16216011@infradead.org>
In-Reply-To: <20080824165522.16216011@infradead.org>
Accept-Language: en-US, de-CH
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-CH
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 25 Aug 2008 07:58:20.0951 (UTC) FILETIME=[57771270:01C90688]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 25 Aug 2008 01:35:49 +0200
> Ingo Oeser <ioe-lkml@rameria.de> wrote:
>
>> Is the application linked statically? If not, code pages might be
>> mapped privately and have been written to due to relocation.
>>
>> Link everything statically to avoid this.
>
> ... static linking has severe downsides though. You can also just use
> prelink to avoid relocations in practice.

Hm. I did a
cat /proc/`pidof thebigbinary`/smaps | grep Dirty
and got only about 3 MByte of dirty data. So it looks like this is not the (whole) problem (just a part). The Rss part of the /proc/pid/smaps report counts to about 14 MBytes. What is this saying exactly? I thought, those are the pages which aren't stealed by the VM from the app. Am I right?

Marcel
