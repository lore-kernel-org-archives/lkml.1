Return-Path: <linux-kernel-owner+w=401wt.eu-S1763956AbXGFRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763956AbXGFRTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 13:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761199AbXGFRTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 13:19:11 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45509 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760493AbXGFRTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 13:19:09 -0400
Message-ID: <468E7985.7050502@zytor.com>
Date: Fri, 06 Jul 2007 10:19:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Gautam Singaraju <gautam.singaraju@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: syscall macro fails upon compilation
References: <f8b2ccd40707051509tcbce704y3e5b114580069039@mail.gmail.com> <468D6D1F.4040008@zytor.com> <p73r6nl21fe.fsf@bingen.suse.de> <468E699C.1000502@zytor.com> <20070706170512.GA8174@one.firstfloor.org>
In-Reply-To: <20070706170512.GA8174@one.firstfloor.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> They were *always* broken for 64-bit arguments on 32-bit machines, however.
> 
> Well syscall() doesn't support that at all (unless you split by hand)
> 

On i386 it just happens to work, because the calling convention is
equivalent.  On some other 32-bit platforms it works that way as well;
on others, it fails.

To do it right you need a proper assembly stub generator.

	-hpa

