Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbYBAKv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbYBAKv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbYBAKvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:51:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36866 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801AbYBAKvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:51:19 -0500
Date: Fri, 1 Feb 2008 11:50:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: Remove long dead cyrix mtrr code
Message-ID: <20080201105058.GC27178@elte.hu>
References: <1201858747.23523.103.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201858747.23523.103.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> cyrix_arr_init was #if 0 all the way back to at least v2.6.12.
> 
> This was the only place where arr3_protected was set to anything but 
> zero.  Eliminate this variable.

thanks, tentatively applied. I've Cc:-ed Alan: do you agree with the 
removal of this dead legacy code? Cyrix CPUs, while being very old, are 
occasionally tested, and i'm not aware of any well-known breakage in 
this area.

	Ingo
