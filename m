Return-Path: <linux-kernel-owner+w=401wt.eu-S1759164AbYGAJdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759164AbYGAJdY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758295AbYGAJdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:33:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758103AbYGAJdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:33:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, TAKADA Yoshihito <takada@mbf.nifty.com>
Subject: Re: [PATCH] x86 ptrace: fix PTRACE_GETFPXREGS error
In-Reply-To: Ingo Molnar's message of  Tuesday, 1 July 2008 11:02:04 +0200 <20080701090204.GA1729@elte.hu>
References: <20080630.134445.193700135.takada@mbf.nifty.com>
	<20080630210241.93738154077@magilla.localdomain>
	<20080701090204.GA1729@elte.hu>
X-Shopping-List: (1) Titanic arguments
   (2) Voluptuous turkeys
   (3) Apocalyptic guilt bacon
   (4) Superfluous idiosyncratic annoyers
Message-Id: <20080701093212.6D9DA15420E@magilla.localdomain>
Date: Tue,  1 Jul 2008 02:32:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> since the original fix is already upstream, i've applied the delta patch 
> below. Should we still do this for v2.6.26 or can we defer it to 
> v2.6.27? As ptrace is the only user of this facility for now this would 
> be an identity transformation AFAICS and the v2.6.26 release is very 
> close.

I don't think there's a problem with 2.6.26 either way.  I agree that the
user_regset internal API does not matter much before 2.6.27.

My patch alone applies to 2.6.25, which is why I CC'd it to stable.
I think applying that (and not takada's patch) to stable-2.6.25
would be best.


Thanks,
Roland
