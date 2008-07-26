Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbYGZNtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbYGZNtB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbYGZNst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:48:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44995 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbYGZNss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:48:48 -0400
Date: Sat, 26 Jul 2008 15:48:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] x86: usb debug port early console v4
Message-ID: <20080726134828.GF4401@elte.hu>
References: <200807231252.20371.yhlu.kernel@gmail.com> <200807231400.53957.yhlu.kernel@gmail.com> <200807231739.39620.yhlu.kernel@gmail.com> <200807241729.41132.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807241729.41132.yhlu.kernel@gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> based on work from Eric, and add some timeout so don't dead loop when 
> debug device is not installed
> 
> v2: fix checkpatch warning
> v3: move ehci struct def to linux/usrb/ehci_def.h from host/ehci.h
>     also add CONFIG_EARLY_PRINTK_DBGP to disable it by default
> v4: address comments from Ingo, seperate ehci reg def moving to another patch
>     also add auto detect port that connect to debug device for Nvidia southbridge
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

applied to tip/x86/early-printk - thanks Yinghai.

	Ingo
