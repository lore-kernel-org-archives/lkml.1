Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbYJ0LhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbYJ0LhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 07:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYJ0Lg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 07:36:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54993 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbYJ0Lg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 07:36:56 -0400
Date: Mon, 27 Oct 2008 12:36:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pavel Machek <pavel@suse.cz>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Purdie <rpurdie@rpsys.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] SGI X86 UV: Provide a System Activity Indicator
	driver
Message-ID: <20081027113621.GA5631@elte.hu>
References: <4901AF28.4070606@sgi.com> <20081024120103.GD1680@elf.ucw.cz> <20081024120544.GA9812@elte.hu> <4901BF30.3090708@sgi.com> <87mygt9815.fsf@basil.nowhere.org> <490249CF.2080308@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490249CF.2080308@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> > The idle thread always has pid 0. So if the timer sees 
> > current->pid == 0 it interrupted idle.

that's still hacky as it hardcodes the idle == pid-0 assumption. 
Please use the idle_cpu() function of the scheduler instead.

	Ingo
