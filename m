Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbYCVLRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbYCVLRw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 07:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYCVLRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 07:17:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47373 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbYCVLRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 07:17:44 -0400
Date: Sat, 22 Mar 2008 12:17:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 handle_vm86_trap cleanup
Message-ID: <20080322111728.GD13264@elte.hu>
References: <20080317092108.EC6C626F995@magilla.localdomain> <20080321103946.GO20420@elte.hu> <20080322035357.4B43326F992@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080322035357.4B43326F992@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0144]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> > for the record, this also changes semantics, because previously we'd 
> > permanently unblock SIGTRAP (most certainly as a hack, to be able to 
> > do the send_sig()), while now we use force_sig() which just ignores 
> > the blocked mask. (and i agree with your fix of course)
> 
> That's not so.  force_sig_info (called by force_sig) removes the 
> signal from the blocked set too.  That is the only way to get the 
> signal ever to be dequeued.

ah, indeed, i missed that :)

	Ingo
