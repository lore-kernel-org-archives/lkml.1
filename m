Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbZCOSzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbZCOSzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 14:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZCOSzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 14:55:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54823 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbZCOSzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 14:55:42 -0400
Date: Sun, 15 Mar 2009 19:55:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: print out in e820_update_range()
Message-ID: <20090315185519.GB19737@elte.hu>
References: <49BCB557.3030000@kernel.org> <20090315080717.GA18978@elte.hu> <49BD42F5.7070808@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BD42F5.7070808@kernel.org>
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


* Yinghai Lu <yinghai@kernel.org> wrote:

> Ingo Molnar wrote:
> > * Yinghai Lu <yinghai@kernel.org> wrote:
> > 
> >> Impact: to find crazy calling
> >>
> >> try to print out more info, to catch wrong calling
> > 
> > Could we detect incorrect parameters more directly as well, via 
> > a check and a panic()?
> 
> only valid checking seems to be 
> virt_to_phys(_text), virt_to_phys(_end)
> 
> 
> if (new_type == E820_RESERVED && start >= virt_to_phys(_text) && start <= virt_to_phys(_end)) 
> 	panic("try to update to e820 range for kernel to RESERVED!");

hm, seems a bit too specialized.

	Ingo
