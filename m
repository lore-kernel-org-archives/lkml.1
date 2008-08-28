Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbYH1TLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbYH1TLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYH1TK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:10:57 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57797 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbYH1TK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:10:57 -0400
Message-ID: <48B6F77C.70702@cs.helsinki.fi>
Date: Thu, 28 Aug 2008 22:07:40 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] bitfields API
References: <20080828183223.GA30781@localhost.localdomain> <20080828184025.GA22165@x200.localdomain> <19f34abd0808281146o7a00388eie9322ff778665961@mail.gmail.com> <20080828190533.GA22416@x200.localdomain>
In-Reply-To: <20080828190533.GA22416@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

Alexey Dobriyan wrote:
>> Would it help (to make this less
>> horrible) to omit the type declaration and have just the bitfield
>> members as arguments to the macro?
> 
> Or you can parse instruction stream a bit more.

Uhm, I'm not sure how that would work out. I mean, we'd need to see if 
parts of the loaded byte are used or not... Doesn't sound practical or 
too pretty.

		Pekka
