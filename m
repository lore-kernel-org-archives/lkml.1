Return-Path: <linux-kernel-owner+w=401wt.eu-S933720AbYAaRxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720AbYAaRxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbYAaRxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:53:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357AbYAaRxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:53:04 -0500
Message-ID: <47A2086F.2040501@zytor.com>
Date: Thu, 31 Jan 2008 09:42:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       davej@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH] x86: introduce /dev/mem restrictions with a config option
References: <20080130124853.184ef782@laptopd505.fenrus.org>	<Pine.LNX.4.64.0801311729190.4864@fbirervta.pbzchgretzou.qr> <20080131090839.7f610a6a@laptopd505.fenrus.org>
In-Reply-To: <20080131090839.7f610a6a@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Thu, 31 Jan 2008 17:53:04 +0100 (CET)
> Jan Engelhardt <jengelh@computergmbh.de> wrote:
> 
>> On Jan 30 2008 12:48, Arjan van de Ven wrote:
>>> Subject: [PATCH] x86: introduce /dev/mem restrictions with a config
>>> option
>>>
>>> This patch introduces a restriction on /dev/mem: Only non-memory can
>>> be read or written unless the newly introduced config option is set.
>> Would not it be nicer to add a /dev/pcimem that implements the given 
>> restrictive semantics?
>>
>> Maybe it's just wishful thinking, but I am dreaming of an
>> unprivileged X, and /dev/pcimem (owned by an 'x11' user or so) would
>> be a step in that direction.
> 
> /dev/pcimem is wrong; X can use the exact bar in sysfs already.
> This is more for compatibility with legacy X
> 

Legacy X, and non-BAR X memory (originally ISA, of course; now probably 
more often "stolen system memory").

	-hpa
