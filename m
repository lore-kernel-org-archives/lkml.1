Return-Path: <linux-kernel-owner+w=401wt.eu-S934844AbXEHW1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934844AbXEHW1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934712AbXEHW1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:27:44 -0400
Received: from terminus.zytor.com ([192.83.249.54]:37353 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934658AbXEHW1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:27:43 -0400
Message-ID: <4640F94F.5030301@zytor.com>
Date: Tue, 08 May 2007 15:27:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make bootsector stub 16-bit-only (i386)
References: <20070505104452.GA30944@mailshack.com> <20070508032817.e4734798.akpm@linux-foundation.org> <20070508183232.GA13225@mailshack.com> <4640C55B.6030908@zytor.com> <20070508191904.GA13368@mailshack.com>
In-Reply-To: <20070508191904.GA13368@mailshack.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> On Tue, May 08, 2007 at 11:45:47AM -0700, H. Peter Anvin wrote:
>> Alexander van Heukelum wrote:
>>> Oh! A padding hole in a struct! That could be a problem. If the freeze
>>> is after decompression, could you test if this makes it work again?
>>>
>> The correct fix is to apply __attribute__((packed)) to this structure.
> 
> Yeah, I thought about that possibility too, but the struct didn't need
> that (in my opinion ugly) annotation before. Oh well, here you go.
> 

It did need it, however, it just "happened to work" anyway.

Yes, it's ugly, but the damage is already done.

	-hpa
