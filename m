Return-Path: <linux-kernel-owner+w=401wt.eu-S1761458AbZE3LWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761458AbZE3LWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 07:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759674AbZE3LWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 07:22:39 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51661 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759666AbZE3LWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 07:22:39 -0400
Date: Sat, 30 May 2009 13:22:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Thomas Gleixner <tglx@linutronix.de> Suresh Siddha" 
	<suresh.siddha@intel.com>,
       Tejun Heo <tj@kernel.org>,
       Venkatesh Pallapadi <venkatesh.pallapadi@intel.com>,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [GIT PULL] x86 fixes for 2.6.30-rc8
Message-ID: <20090530112234.GB1395@ucw.cz>
References: <200905252003.n4PK3sFi014919@voreg.hos.anvin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905252003.n4PK3sFi014919@voreg.hos.anvin.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1535,6 +1535,10 @@ and is between 256 and 4096 characters. It is defined in the file
>  			register save and restore. The kernel will only save
>  			legacy floating-point registers on task switch.
>  
> +	noxsave		[BUGS=X86] Disables x86 extended register state save
> +			and restore using xsave. The kernel will fallback to
> +			enabling legacy floating-point and sse state.
> +

Does that mean apps using sse8 will see their registers corrupted if
this option is used? Or are new registers sets always added in a way
that kernel has to enable them first?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
