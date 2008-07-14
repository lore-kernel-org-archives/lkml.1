Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbYGNU6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbYGNU6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 16:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbYGNU6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 16:58:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58157 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbYGNU6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 16:58:14 -0400
Message-ID: <487BBDCB.7050303@zytor.com>
Date: Mon, 14 Jul 2008 13:57:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 changes for v2.6.27
References: <20080714135034.GA7013@elte.hu> <alpine.LFD.1.10.0807141346170.3305@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807141346170.3305@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Things like this _really_ irritate me:
> 
> 	Memtest (MEMTEST) [Y/n/?] (NEW) ?
> 
> why the hell is that defaulting to "on"?
> 
> The rule of thumb should be:
> 
> 	NO NEW FEATURES SHOULD _EVER_ DEFAULT TO 'ON'!
> 
> I do realize that developers always think that _their_ particular cool new 
> feature is so important that it should default to 'on', but that's always 
> the case, and it's _always_ wrong.
> 

I'm a bit surprised that you'd say that for something that is a 
hardware-testing feature that needs a command-line option to be enabled 
at runtime.  I have always presumed that the default value is the 
recommended value, and I would think that that is what most people would 
assume.

	-hpa
