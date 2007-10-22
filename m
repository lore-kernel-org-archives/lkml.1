Return-Path: <linux-kernel-owner+w=401wt.eu-S1754494AbXJVSwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbXJVSwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbXJVSwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:52:05 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:60722 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbXJVSwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:52:05 -0400
Message-ID: <471CF150.9090707@tiscali.nl>
Date: Mon, 22 Oct 2007 20:52:00 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Rik van Riel <riel@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] return hidden bug
References: <471BF741.2020501@tiscali.nl>	 <20071021214209.1a7567d7@bree.surriel.com>	 <2c0942db0710220942he5e9199i2e327df3c5676a6a@mail.gmail.com>	 <471CE453.5050208@tiscali.nl> <2c0942db0710221112g7c7d99caj7feb0c2ac5de17e7@mail.gmail.com>
In-Reply-To: <2c0942db0710221112g7c7d99caj7feb0c2ac5de17e7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:

>>> I'm sorry, perhaps I poured myself a cup of stupid this morning, but
>>> isn't the above patch effectively introducing a BUG where none could
>>> be reached before? In other words, for the patch to have zero
>>> behavioral change, wouldn't it have to remove the BUG() altogether?
>> True, but obviously not intended. I think the intention was to expose this bug.
> 
> Arguing intentions is very dangerous. I've written code like that
> where the intention is to make it simple to turn a printk into a full
> bug and back and forth during development. At the end of the day, the
> fact remains that you're changing behavior.
> 
> Let me turn this around. Do you have an alpha and have you tried out
> your patch? If not, then I'd suggest turning it into a WARN_ON(1)
> instead, as in this specific case you're risking turning what was a
> working system into one that doesn't.

No, I haven't and, I will change it, but it's included with my other
changes. see the reply that I'll write shortly for.
[PATCH retry] return hidden bug and unlock bugs.

Roel


