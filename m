Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbYIIG43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbYIIG43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 02:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbYIIG4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 02:56:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51357 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbYIIG4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:56:21 -0400
Date: Tue, 9 Sep 2008 08:56:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Noonan <steven@uplinklabs.net>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: fix HPET compiler error when not using
	CONFIG_PCI_MSI
Message-ID: <20080909065602.GB27747@elte.hu>
References: <1220915951-11434-1-git-send-email-steven@uplinklabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220915951-11434-1-git-send-email-steven@uplinklabs.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Steven Noonan <steven@uplinklabs.net> wrote:

> Added dummy function for hpet_setup_msi_irq().
> 
> Signed-off-by: Steven Noonan <steven@uplinklabs.net>

applied to tip/timers/hpet-percpu - thanks Steven.

I'm wondering, what is the compiler error you got? I havent seen any in 
my testing.

	Ingo
