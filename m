Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbXLTUeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbXLTUeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 15:34:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbXLTUeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 15:34:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45081 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbXLTUeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 15:34:12 -0500
Date: Thu, 20 Dec 2007 21:33:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com
Subject: Re: [PATCH 13/15] move patching code to arch-specific file.
Message-ID: <20071220203312.GA21251@elte.hu>
References: <1198181224677-git-send-email-gcosta@redhat.com> <11981812412879-git-send-email-gcosta@redhat.com> <11981812771615-git-send-email-gcosta@redhat.com> <1198181309285-git-send-email-gcosta@redhat.com> <11981813192341-git-send-email-gcosta@redhat.com> <11981813292926-git-send-email-gcosta@redhat.com> <11981813384090-git-send-email-gcosta@redhat.com> <1198181348746-git-send-email-gcosta@redhat.com> <11981813592589-git-send-email-gcosta@redhat.com> <20071220203148.GA20826@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220203148.GA20826@elte.hu>
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

> this patch adds the paravirt_patch_32.o:
> 
> > -obj-$(CONFIG_PARAVIRT)		+= paravirt.o
> > +obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_32.o
> 
> but does not add that file nor any other rule to build that target, so 
> it fails to build with the attached config:
> 
> make[1]: *** No rule to make target 
>  `arch/x86/kernel/paravirt_patch_32.o', needed by 
>  `arch/x86/kernel/built-in.o'.  Stop.

if it's just that single missing file then please send me a patch that 
adds that file and i'll add it to this patch. (instead of resending the 
whole series)

	Ingo
