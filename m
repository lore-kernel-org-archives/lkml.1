Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbYJ0UrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbYJ0UrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYJ0UrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:47:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:54445 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754396AbYJ0UrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:47:05 -0400
Cc: David Miller <davem@davemloft.net>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       torvalds@osdl.org, maxk@qualcomm.com, tglx@linutronix.de
Message-Id: <4CC6D7AE-2970-47AE-8473-9013A613F837@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: benh@kernel.crashing.org
In-Reply-To: <1225139236.8004.21.camel@pasglop>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH] genirq: Set initial default irq affinity to just CPU0
Date: Mon, 27 Oct 2008 15:45:59 -0500
References: <1224863858-7933-1-git-send-email-galak@kernel.crashing.org> <20081024.161813.193686281.davem@davemloft.net> <1224970389.7654.473.camel@pasglop> <20081025.210412.206011121.davem@davemloft.net> <1225002815.7654.487.camel@pasglop> <8440180C-A3B1-4436-9CDF-C6BA9A01F8CD@kernel.crashing.org> <1225139236.8004.21.camel@pasglop>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 27, 2008, at 3:27 PM, Benjamin Herrenschmidt wrote:

> On Mon, 2008-10-27 at 08:43 -0500, Kumar Gala wrote:
>>
>> While we have the comment the code appears not to really follow it.
>> We appear to write 1 << hard_smp_processor_id().
>
> That code is called by each CPU that gets onlined and OR's it's
> bit in the mask.

ahh, I see now.

- k
