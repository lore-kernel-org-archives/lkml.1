Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbXLGHZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbXLGHZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 02:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbXLGHYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 02:24:55 -0500
Received: from echo836.server4you.de ([85.25.140.112]:55237 "EHLO
	mail.pianoinflames.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbXLGHYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 02:24:54 -0500
Message-ID: <4758F53E.6010505@pianoinflames.de>
Date: Fri, 07 Dec 2007 08:24:46 +0100
From: Marco Gatti <marco@pianoinflames.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug: get EXT3-fs error Allocating block in system zone
References: <4755BEA1.4090604@pianoinflames.de> <20071206162500.1f76a234.akpm@linux-foundation.org> <alpine.LFD.0.9999.0712061631510.13796@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712061631510.13796@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds schrieb:
> 
> But the disk errors are something else, doesn't ring a bell. Sounds like 
> IO corruption on the group descriptor block or something like that. Might 
> be worth testing to see if the problem goes away with less than 4GB of 
> RAM..
> 

Thanks, I'll try this, to see if there's a dependency on that. But it's 
not a really solution for a virtualization system to work with less 
memory ;-). I also read that there's maybe a problem with intel graphics 
media accelerator driver in conjunction with more than 4GB RAM and 
kernel will hang on boot, but I think this is fixed, I can boot. So 
securly, I put out i915 series drivers and frame buffer support in 
kernel config. The grahpics adapter onboard works with shared memory 
technology. I configured 128M in BIOS...
