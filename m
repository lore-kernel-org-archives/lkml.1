Return-Path: <linux-kernel-owner+w=401wt.eu-S965015AbXGSO5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965015AbXGSO5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 10:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938345AbXGSO5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 10:57:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39939 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937927AbXGSO5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 10:57:03 -0400
Message-ID: <469F7BB9.1000202@garzik.org>
Date: Thu, 19 Jul 2007 10:56:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@stusta.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [58/58] x86: remove support for the Rise CPU
References: <200707191154.642492000@suse.de> <20070719104825.GR3801@stusta.de> <20070719121340.08da9bbf@the-village.bc.nu> <200707191403.39372.ak@suse.de>
In-Reply-To: <200707191403.39372.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Thursday 19 July 2007 13:13:40 Alan Cox wrote:
>>> - It's not only code, it also bloats everyone's kernel image.
>> Its a miniscule piece of code that is discarded on boot. Yes it might
>> make the image 100 bytes longer, but have you priced a 160GB disk
>> recently. I don't think 100 bytes of disk and 0 of memory really is worth
>> saving for any risk at all. Its not even worth the time to apply the
>> patch.
> 
> The patch is already applied.

Er, huh?  It's not upstream.


> Besides the CPU will likely boot even without special handling.

You don't know this.  Why risk it?  Just leave the CPU magic as-is.

	Jeff


