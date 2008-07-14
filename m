Return-Path: <linux-kernel-owner+w=401wt.eu-S1758003AbYGNWB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbYGNWB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYGNWBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:01:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753546AbYGNWBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:01:19 -0400
Date: Mon, 14 Jul 2008 15:00:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 changes for v2.6.27
In-Reply-To: <alpine.LFD.1.10.0807141346170.3305@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807141459440.2944@woody.linux-foundation.org>
References: <20080714135034.GA7013@elte.hu> <alpine.LFD.1.10.0807141346170.3305@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 14 Jul 2008, Linus Torvalds wrote:
> 
> Things like this _really_ irritate me:
> 
> 	Memtest (MEMTEST) [Y/n/?] (NEW) ?

.. and now I get all the FTRACE stuff _individually_, with MMIOTRACE 
(which is likely the _least_ interesting one for any normal person) being 
turned on by default.

Ingo, you _really_ need to look at those Kconfig options. They're insane.

		Linus
