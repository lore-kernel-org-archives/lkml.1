Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbZLDTzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbZLDTzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 14:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757097AbZLDTzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 14:55:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:49201 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028AbZLDTzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 14:55:37 -0500
Message-ID: <55137.84.105.60.153.1259956481.squirrel@gate.crashing.org>
In-Reply-To: <4B194722.9020705@zytor.com>
References: <20091204092119.GA9707@laptop>
    <8B1FEF0C-5D71-4D64-ADC3-1EE60F50779F@kernel.crashing.org>
    <4B194722.9020705@zytor.com>
Date: Fri, 4 Dec 2009 20:54:41 +0100 (CET)
Subject: Re: x86: Is 'volatile' necessary for readb/writeb and friends?
From: "Segher Boessenkool" <segher@kernel.crashing.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Segher Boessenkool" <segher@kernel.crashing.org>,
       "Ahmed S. Darwish" <darwish.07@gmail.com>, x86@kernel.org,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Ingo Molnar" <mingo@redhat.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> static inline unsigned char readb(const volatile void __iomem *addr) {
>>
>> This "volatile" is meaningless.
>
> Wrong.  "volatile" here is an assertion that it is safe to pass pointer
> to a volatile object to this function.

Yes, sorry.  What I meant is: this volatile has no effect on what
the rest of the function does.

> Either way, it works, it is guaranteed to be safe, and removing it can
> only introduce bugs, not remove them.

Oh definitely, I wasn't suggesting otherwise.


Segher

