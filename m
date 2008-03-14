Return-Path: <linux-kernel-owner+w=401wt.eu-S1758420AbYCNSEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420AbYCNSEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813AbYCNSE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:04:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3120 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754548AbYCNSE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:04:26 -0400
Date: Fri, 14 Mar 2008 19:04:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Mark early_printk as asmlinkage
Message-ID: <20080314180401.GA6722@ucw.cz>
References: <1205330034-28828-1-git-send-email-jirislaby@gmail.com> <1205330034-28828-2-git-send-email-jirislaby@gmail.com> <47D7E2FB.2020801@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D7E2FB.2020801@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed 2008-03-12 15:04:43, H. Peter Anvin wrote:
> Jiri Slaby wrote:
> >It's not explicitly marked as asmlinkage, but invoked 
> >from x86_32
> >startup code with parameters on stack.
> >
> >No other architectures define early_printk and none of 
> >them are affected
> >by this change, since defines asmlinkage as empty token.
> 
> NAK.
> 
> The regparm ABI for x86-32 uses parameters on the stack 
> when the function is varadic (as it is here), so this is 
> unnecessary.

I'd call asmlinkage kind of documentation, then. Not everyone is as
good with x86 abi as you are...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
