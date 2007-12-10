Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbXLJQmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbXLJQmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 11:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbXLJQm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 11:42:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44182 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbXLJQm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 11:42:28 -0500
Message-ID: <475D6B44.8050707@zytor.com>
Date: Mon, 10 Dec 2007 08:37:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Arjan van de Ven <arjan@infradead.org>, Chris Snook <csnook@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org> <474F6E7A.3090705@redhat.com> <474F7DC4.8000607@zytor.com> <20071129194027.10046988@laptopd505.fenrus.org> <474F8984.4010602@zytor.com> <Pine.LNX.4.64.0711302017100.18767@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0711302017100.18767@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Nov 29 2007 19:54, H. Peter Anvin wrote:
>> Arjan van de Ven wrote:
>>>> Anyway, I don't think compiling bc is hard on anything which has a C
>>>> compiler.
>>> alternative is to just also ship the precomputed values ;-)
>>>
>> Oh, come on... it's not like bc is some obscure thing.  It's a POSIX utility.
> 
> People try building linux on not-so-posix systems these days...
> 

Are you talking about Cygwin (which has bc prepackaged)?  Even if not, I 
would be *extremely* surprised to find something that can build the 
Linux kernel which can't build GNU bc out of the box.

In fact, I would be rather surprised to find that the Linux kernel 
builds on anything which doesn't come prepackaged with bc.

	-hpa
