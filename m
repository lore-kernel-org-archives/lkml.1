Return-Path: <linux-kernel-owner+w=401wt.eu-S933181AbXAXHJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181AbXAXHJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 02:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933182AbXAXHJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 02:09:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47525 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933181AbXAXHJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 02:09:51 -0500
Date: Wed, 24 Jan 2007 08:07:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
Message-ID: <20070124070701.GA17654@elte.hu>
References: <20070123211159.178138000@localhost.localdomain> <1169604991.19471.95.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169604991.19471.95.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	0.5 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4892]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> To lessen Andrews burden it would be wise to integrate the two trees 
> prior to anything going into -mm .. [...]

i disagree. Thomas' tree has been tested in -rt for some time already, 
and he's the author of this code so as far as i'm concerned he calls the 
shots of what to do and in what order to do. He did the overwhelming 
majority of regression fixes of dynticks/hrt stuff both in -mm and in 
-rt. So why should i not take his queue over yours? Last i checked your 
queue didnt really do anything substantial to the code - other than 
shuffling around wast amounts of code around. Even this latest iteration 
from Thomas that is now in -rt is working well on the target platform we 
are aiming for currently (i686). (and it's working on x86_64 as well in 
-rt)

	Ingo
