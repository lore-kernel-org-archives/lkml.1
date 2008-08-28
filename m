Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbYH1SoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbYH1SoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYH1SoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:44:05 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36543 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbYH1SoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:44:04 -0400
Message-ID: <48B6F12F.1010909@cs.helsinki.fi>
Date: Thu, 28 Aug 2008 21:40:47 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] bitfields API
References: <20080828183223.GA30781@localhost.localdomain> <20080828184025.GA22165@x200.localdomain>
In-Reply-To: <20080828184025.GA22165@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

Alexey Dobriyan wrote:
> On Thu, Aug 28, 2008 at 08:32:23PM +0200, Vegard Nossum wrote:
>> How do you feel about this patch? It's all about making kmemcheck more
>> useful... and not much else. Does it have any chance of entering the
>> kernel along with kmemcheck (when/if that happens)?
> 
> DEFINE_BITFIELD is horrible.

Heh, heh, one alternative is to have a kmemcheck_memset() thingy that 
unconditionally zeroes bit fields and maybe is a no-op when kmemcheck is 
disabled.
