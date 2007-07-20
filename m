Return-Path: <linux-kernel-owner+w=401wt.eu-S939240AbXGTXny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939240AbXGTXny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765468AbXGTXnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:43:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50656 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763902AbXGTXnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:43:42 -0400
Message-ID: <46A148A2.2070805@zytor.com>
Date: Fri, 20 Jul 2007 16:43:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Create clflush() inline, remove hardcoded wbinvd
References: <1184885740.16311.19.camel@t60>	 <200707202119.l6KLJwcd004205@tazenda.hos.anvin.org> <1184974651.16311.35.camel@t60>
In-Reply-To: <1184974651.16311.35.camel@t60>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> On Fri, 2007-07-20 at 14:19 -0700, H. Peter Anvin wrote:
>> Create an inline function for clflush(), with the proper arguments,
>> and use it instead of hard-coding the instruction.
>>
>> This also removes one instance of hard-coded wbinvd, based on a patch
>> by Bauder de Oliveira Costa.
> Hey, Who's that guy that got a name so close to mine? ;-)

That would be Mr. Typo!

>> Cc: Andi Kleen <andi@firstfloor.org>
>> Cc: Glauber de Oliveira Costa <gcosta@redhat.com>

I got it right here at least :-/

	-hpa
