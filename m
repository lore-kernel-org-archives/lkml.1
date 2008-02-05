Return-Path: <linux-kernel-owner+w=401wt.eu-S1760853AbYBEVKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853AbYBEVKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:10:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759036AbYBEVKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:10:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41193 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713AbYBEVKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:10:00 -0500
Message-ID: <47A8D088.7050209@zytor.com>
Date: Tue, 05 Feb 2008 13:09:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] x86 updates
References: <20080204161219.GA8092@elte.hu> <alpine.LFD.1.00.0802051043550.9374@woody.linux-foundation.org> <20080205192236.GA26426@uranus.ravnborg.org> <20080205210508.GA14708@elte.hu>
In-Reply-To: <20080205210508.GA14708@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> btw., what's the practical consequence of getting these section flags 
> wrong - for example writable data can end up in executable section 
> accidentally and be marked readonly by RODATA? Or can anything more 
> serious happen? (they cannot get into any of the discarded sections, we 
> filter for them explicitly in the linker scripts)
> 

The practical consequences are probably zero - *except* for getting the 
"a" flag wrong, as !a sections will never be loaded.

Technically we should also specify @progbits or @nobits on sections, 
however, I think @progbits is the default.

	-hpa
