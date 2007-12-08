Return-Path: <linux-kernel-owner+w=401wt.eu-S1754727AbXLHVVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727AbXLHVVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 16:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbXLHVVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 16:21:36 -0500
Received: from echo836.server4you.de ([85.25.140.112]:57077 "EHLO
	mail.pianoinflames.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754012AbXLHVVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 16:21:35 -0500
Message-ID: <475B0AD7.10500@pianoinflames.de>
Date: Sat, 08 Dec 2007 22:21:27 +0100
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

Today, I tested with different amounts of RAM:

2 GB: everything works fine
4 GB: same issue as described before with allocating block in system zone

So what to do, in order to use more than 2 Gigs of RAM?

Marco

