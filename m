Return-Path: <linux-kernel-owner+w=401wt.eu-S1763514AbYDZAGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763514AbYDZAGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 20:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756908AbYDZAGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 20:06:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51702 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbYDZAGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 20:06:42 -0400
Message-ID: <481271F4.7060401@zytor.com>
Date: Fri, 25 Apr 2008 17:06:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] x86 PAT changes
References: <20080424225625.GB8717@elte.hu> <alpine.LFD.1.10.0804251351511.2779@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0804251351511.2779@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> So why is PAT dependent on NONPROMISC_DEVMEM here?
> 
> It seems pointless and wrong. Somebody might want to have both the full 
> /dev/mem and PAT.
> 

The problem is that that can create cached/uncached aliases, which can 
cause some processors to lock up (especially AMD is known to have a lot 
of errata in this area.)

	-hpa
