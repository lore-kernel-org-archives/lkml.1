Return-Path: <linux-kernel-owner+w=401wt.eu-S933048AbXCEKda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048AbXCEKda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933051AbXCEKda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:33:30 -0500
Received: from nz-out-0506.google.com ([64.233.162.233]:10113 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933048AbXCEKd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:33:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ElR2zyD6CVpO2RYg+oZca1lf7iY787/qsv1Po4FA0l69urySgaNjqS314Uk9RSkWAKLbA2VEfdvH689So1nasMc5kEmL7EezFRLDkYO3MRDt+mGgNQQC/HZZ+Zmpf040fUYvPG2fAoKVoYkrVem+8X2VEwVoZ325dVOmA6nIGog=
Subject: Re: [4/6] 2.6.21-rc2: known regressions
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Nelless <andrew@nelless.net>, Len Brown <len.brown@intel.com>,
       linux-acpi@vger.kernel.org, Jiri Kosina <jikos@jikos.cz>,
       Richard Purdie <rpurdie@rpsys.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Alex Romosan <romosan@sycorax.lbl.gov>,
       David Miller <davem@davemloft.net>,
       James Simmons <jsimmons@infradead.org>, benh@kernel.crashing.org,
       Andreas Schwab <schwab@suse.de>
In-Reply-To: <20070305015039.GI3441@stusta.de>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015039.GI3441@stusta.de>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 18:35:19 +0800
Message-Id: <1173090919.6782.13.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 02:50 +0100, Adrian Bunk wrote:
> This email lists some known regressions in 2.6.21-rc2 compared to 2.6.20
> that are not yet fixed in Linus' tree.
> 
> If you find your name in the Cc header, you are either submitter of one
> of the bugs, maintainer of an affectected subsystem or driver, a patch
> of you caused a breakage or I'm considering you in any other way
> possibly involved with one or more of these issues.
> 
> Due to the huge amount of recipients, please trim the Cc when answering.
> 
> 
> Subject    : Asus A8N-VM motherboard:
>              framebuffer/console boot failure boot failure (ACPI related)
> References : http://lkml.org/lkml/2007/2/23/132
> Submitter  : Andrew Nelless <andrew@nelless.net>
> Caused-By  : Len Brown <len.brown@intel.com>
>              commit 7f8f97c3cc75d5783d0b45cf323dedf17684be19
> Handled-By : Antonino A. Daplas <adaplas@gmail.com>
> Status     : problem is being debugged
> 

This is not a framebuffer nor console problem.

I think Andrew Nelless confirmed that the cause is from the above
commit. How to fix it, I don't know.  Perhaps the
acpi_skip_timer_override boot option has to be used.

Tony

