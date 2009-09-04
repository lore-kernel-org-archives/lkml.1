Return-Path: <linux-kernel-owner+w=401wt.eu-S933724AbZIDQZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724AbZIDQZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933686AbZIDQZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:25:28 -0400
Received: from twosheds.infradead.org ([90.155.92.209]:53972 "EHLO
	twosheds.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933675AbZIDQZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:25:27 -0400
X-Greylist: delayed 3061 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Sep 2009 12:25:27 EDT
Date: Fri, 4 Sep 2009 16:33:18 +0100 (BST)
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       sam@ravnborg.org, tglx@linutronix.de, David.Woodhouse@intel.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: Don't silently override CONFIG_64BIT in
 'make oldconfig'
In-Reply-To: <20090904144857.GA12872@elte.hu>
Message-ID: <alpine.LFD.2.00.0909041631210.14872@twosheds.infradead.org>
References: <tip-5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9@git.kernel.org> <20090904144857.GA12872@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by twosheds.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Sep 2009, Ingo Molnar wrote:


>> x86: Don't silently override CONFIG_64BIT in 'make oldconfig'
>
> -tip testing found that this commit broke the UML build:
>
> /home/mingo/tip/arch/um/Makefile:52:
> /home/mingo/tip/arch/um/Makefile-x86: No such file or directory
> make[1]: *** No rule to make target `/home/mingo/tip/arch/um/Makefile-x86'.  Stop.
> make: *** [sub-make] Error 2

Hm, doesn't that mean that UML has always been broken for ARCH=x86?

-- 
dwmw2
