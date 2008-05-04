Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbYEDIwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbYEDIwb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 04:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbYEDIwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 04:52:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59527 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbYEDIwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 04:52:23 -0400
Date: Sun, 4 May 2008 10:52:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rufus & Azrael <rufus-azrael@numericable.fr>
Cc: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with
	xf86MapVidMem error
Message-ID: <20080504085204.GE21859@elte.hu>
References: <481D72A7.10901@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481D72A7.10901@numericable.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rufus & Azrael <rufus-azrael@numericable.fr> wrote:

> When upgrading to 2.6.25-git18 and above kernel this Xorg error occurs :
>
> xf86MapVidMem: Could not mmap framebuffer (0xf0000000,0x8000000) (Invalid 
> argument)
>
> The latest working kernel was 25-git17 and perhaps is it related to 
> http://lkml.org/lkml/2008/4/28/52

does this X-does-not-start-up problem go away if you disable this 
option:

> CONFIG_X86_PAT=y

?

	Ingo
