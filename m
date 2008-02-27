Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYB0OYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYB0OYz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 09:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbYB0OYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 09:24:46 -0500
Received: from cantor.suse.de ([195.135.220.2]:49155 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbYB0OYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 09:24:46 -0500
Message-ID: <47C57319.4050605@suse.de>
Date: Wed, 27 Feb 2008 15:26:33 +0100
From: Andi Kleen <ak@suse.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [PATCH] reserve_early end-of-conventional-memory to 1MB
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com> <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <47C3053D.5060504@zytor.com> <1203968796.24935.1239027765@webmail.messagingengine.com> <20080226093046.GK9857@elte.hu>
In-Reply-To: <20080226093046.GK9857@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> 
>>> Either way, the code should be shared between 32 and 64 bits. There 
>>> is nothing bitsize-specific about it!
>> Of course. That's also why I already added the old-Dell case ;). But 
>> one problem at a time, please!
> 
> i've applied your patch to x86.git#testing. Feel free to send a 
> code-unification patch too :-)

So you've basically wasted a lot of memory with no concrete breakage
known ...Please reconsider.

-Andi
