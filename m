Return-Path: <linux-kernel-owner+w=401wt.eu-S1757012AbYBYVST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbYBYVST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbYBYVSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:18:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35254 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbYBYVSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:18:10 -0500
Message-ID: <47C3306E.8060401@zytor.com>
Date: Mon, 25 Feb 2008 13:17:34 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [PATCH] reserve_early end-of-conventional-memory to 1MB
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com>   <1203958478.20033.1239002461@webmail.messagingengine.com>   <20080225170134.GA15839@elte.hu>   <20080225180750.GA31054@mailshack.com> <47C3053D.5060504@zytor.com> <1203968796.24935.1239027765@webmail.messagingengine.com>
In-Reply-To: <1203968796.24935.1239027765@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> 
> Hello hpa,
> 
> I failed to find a comment referring to 0x413 or int 0x12 in
> arch/x86/kernel. I do know the comment in Documentation/i386/boot.txt,
> however, suggesting that "INT 12h" _should_ be used, but that it would
> be pointless for zImage and old bzImage kernels, because they _have_
> to be started from 0x90000 anyway. New bzImage kernels do not have
> this limitation, and smart bootloaders simply put them at much
> lower addresses, like 0x40000. (I know: you know.) My point is just
> that the argument not to use 0x413 in the bootloader is not valid
> for this case.
> 

OK, let me see if I can dig up the comment I thought I found at one 
point, and maybe found out the history behind it.  Either that, or find 
out that my memory is faulty ;)

	-hpa
