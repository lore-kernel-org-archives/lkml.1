Return-Path: <linux-kernel-owner+w=401wt.eu-S1751339AbZLDF0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbZLDF0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 00:26:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750766AbZLDF0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 00:26:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:54106 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZLDF0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 00:26:30 -0500
Date: Thu, 3 Dec 2009 21:28:34 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/asm for v2.6.33
Message-ID: <20091203212834.46ad9ab3@infradead.org>
In-Reply-To: <20091203203143.GA25305@elte.hu>
References: <20091203203143.GA25305@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009 21:31:43 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> Linus,
> 
> Please pull the latest x86-asm-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> x86-asm-for-linus
> 
> The most user visible change here is the (default disabled) 
> CONFIG_DEBUG_STRICT_USER_COPY_CHECKS security feature, which uses 
> __builtin_object_size() to validate copy_from_user accesses.
> 

just FYI; this config option will start generating warnings; I've
killed many of those, but those patches have gone via the various
maintainer trees so may come in a few days later in the merge window.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
