Return-Path: <linux-kernel-owner+w=401wt.eu-S1759958AbXGTVeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958AbXGTVeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758280AbXGTVd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:33:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36145 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248AbXGTVdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:33:54 -0400
Message-ID: <46A12A3A.4020305@zytor.com>
Date: Fri, 20 Jul 2007 14:33:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Create clflush() inline, remove hardcoded wbinvd
References: <1184885740.16311.19.camel@t60> <200707202119.l6KLJwcd004205@tazenda.hos.anvin.org> <20070720212741.GB565@one.firstfloor.org>
In-Reply-To: <20070720212741.GB565@one.firstfloor.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Fri, Jul 20, 2007 at 02:19:58PM -0700, H. Peter Anvin wrote:
>> Create an inline function for clflush(), with the proper arguments,
>> and use it instead of hard-coding the instruction.
>>
>> This also removes one instance of hard-coded wbinvd, based on a patch
>> by Bauder de Oliveira Costa.
> 
> I don't see much sense in it. CLFLUSH is not priviledged, paravirt
> doesn't need to change and this adds just an unnecessary layer of abstraction.

The main reason is that everyone seems to invoke it either incorrectly
or suboptimally.

	-hpa
