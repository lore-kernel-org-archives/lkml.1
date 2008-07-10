Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYGJXDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYGJXDg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 19:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYGJXD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 19:03:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34173 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753260AbYGJXD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 19:03:27 -0400
Date: Thu, 10 Jul 2008 16:02:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <alpine.LFD.1.10.0807101549590.2936@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807101601270.2936@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <alpine.LFD.1.10.0807101459000.2936@woody.linux-foundation.org> <20080710224256.AD038154218@magilla.localdomain> <alpine.LFD.1.10.0807101549590.2936@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jul 2008, Linus Torvalds wrote:
> 
> You're ignoring the background question - we expressly _stopped_ doing 
> this long ago. So the real issue was the ".. if you really .." part.

Side note: the fact that 32-bit does it seems to imply it's ok, but it 
bothers me that I know we changed the signal code at some point. Is the 
64-bit code doing the exact _same_ things as 32-bit now? 

		Linus
