Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbXLLSVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbXLLSVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 13:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbXLLSV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 13:21:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42236 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbXLLSV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:21:28 -0500
Date: Wed, 12 Dec 2007 19:20:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 0/19] desc_struct integration
Message-ID: <20071212182057.GA26515@elte.hu>
References: <1196957800568-git-send-email-gcosta@redhat.com> <11974640441088-git-send-email-gcosta@redhat.com> <20071212172019.GA11258@elte.hu> <20071212181111.GA23306@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212181111.GA23306@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > > Ingo, in the absense of further complaints, could you please push 
> > > to the x86 tree?
> > 
> > yeah, i've added them.
> 
> the patches cause a spontaneous reboot on x86 64-bit, around the time 
> when bootup hits user-space. It's due to one of the 25 patches from 
> you today. Config attached.

likely caused by this patch:

  Subject: unify non-paravirt parts of desc.h

_please_ be more careful when unifying. Do check the before/after 
vmlinux - the binary size at least. And watch out for compiler warnings 
as well:

 arch/x86/kernel/process_64.c: In function 'read_32bit_tls':
 arch/x86/kernel/process_64.c:454: warning: passing argument 1 of 'get_desc_base' from incompatible pointer type

i've pulled the patches from the tree for now.

	Ingo
