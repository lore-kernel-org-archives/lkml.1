Return-Path: <linux-kernel-owner+w=401wt.eu-S1762168AbXLTV2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762168AbXLTV2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 16:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757981AbXLTV2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 16:28:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39598 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbXLTV2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 16:28:12 -0500
Date: Thu, 20 Dec 2007 22:26:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 13/15] move patching code to arch-specific file.
Message-ID: <20071220212651.GA11897@elte.hu>
References: <11981812771615-git-send-email-gcosta@redhat.com> <1198181309285-git-send-email-gcosta@redhat.com> <11981813192341-git-send-email-gcosta@redhat.com> <11981813292926-git-send-email-gcosta@redhat.com> <11981813384090-git-send-email-gcosta@redhat.com> <1198181348746-git-send-email-gcosta@redhat.com> <11981813592589-git-send-email-gcosta@redhat.com> <20071220203148.GA20826@elte.hu> <20071220203312.GA21251@elte.hu> <5d6222a80712201322t46591ce2n5cf3248aa2e1dd26@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d6222a80712201322t46591ce2n5cf3248aa2e1dd26@mail.gmail.com>
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


* Glauber de Oliveira Costa <glommer@gmail.com> wrote:

> > > make[1]: *** No rule to make target
> > >  `arch/x86/kernel/paravirt_patch_32.o', needed by
> > >  `arch/x86/kernel/built-in.o'.  Stop.
> >
> > if it's just that single missing file then please send me a patch that
> > adds that file and i'll add it to this patch. (instead of resending the
> > whole series)
> 
> Yeah, I must have forgotten to git-add it. It was building here fine, 
> because I clearly have the file locally ;-)
> 
> I'm attaching a new patch that replaces just this one.

thanks, this did the trick, it builds fine now.

	Ingo
