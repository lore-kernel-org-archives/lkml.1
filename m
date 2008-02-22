Return-Path: <linux-kernel-owner+w=401wt.eu-S932440AbYBVH7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbYBVH7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 02:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbYBVH7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 02:59:41 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:54203 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbYBVH7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 02:59:41 -0500
Date: Fri, 22 Feb 2008 08:59:50 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Regression [Was: Boot hang with stack protector on x86_64]
Message-ID: <20080222075950.GB2660@uranus.ravnborg.org>
References: <Xine.LNX.4.64.0802221121340.20800@us.intercode.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Xine.LNX.4.64.0802221121340.20800@us.intercode.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus.
On Fri, Feb 22, 2008 at 11:29:37AM +1100, James Morris wrote:
> I've been getting an immediate hang on boot since:
> 
> e06b8b98da071f7dd78fb7822991694288047df0 kbuild: allow -fstack-protector to take effect
> 
> This is on an x86_64 system (actually an Intel SDV -- so it might be 
> "special").
This is a regression. Can you please revert this commit.
We can redo it wehn the -fstack-protector stuff are properly fixed in x86.

	Sam

[Kept rest of the mail for reference]

> 
> My .config has the following:
> 
> CONFIG_CC_STACKPROTECTOR=y
> CONFIG_CC_STACKPROTECTOR_ALL=y
> 
> Let me know if you need more information.
> 
> 
> Interestingly, git-bisect was unable to identify the changeset, and 
> reliably mis-identified this as the problem:
> 
> 71c044752cdae89136862495f244d37073e2cf66 V4L/DVB (7080): zr364xx: add support for Pentax Optio 50
> 
> (which I don't even build).
> 
> 
> - James
> -- 
> James Morris
> <jmorris@namei.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
