Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbXLDOKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbXLDOKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 09:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbXLDOKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 09:10:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56172 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473AbXLDOKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 09:10:36 -0500
Date: Tue, 4 Dec 2007 15:09:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com
Subject: Re: [PATCH 0/10] Integrate msr.h
Message-ID: <20071204140939.GA16328@elte.hu>
References: <11967666042130-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11967666042130-git-send-email-gcosta@redhat.com>
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


* Glauber de Oliveira Costa <gcosta@redhat.com> wrote:

> Hello,
> 
> This series of patches integrates msr.h header. What it really does, 
> is a series of steps to allow us to get rid of duplicate code between 
> i386 and x86_64 versions
> 
> With this done, achieving paravirt for x86_64 gets really easy, just a 
> couple of extra code.

thanks, the patches look certainly sane and i've picked them up into 
x86.git. A quick build & boot test was successful on both 64-bit and 
32-bit, with paravirt on/off. I've pushed out the latest tree into the 
'mm' branch of:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-x86.git

minor nit: some of your patches had scripts/checkpatch.pl failures, 
could you try to fix them up? (If possible then as a follow-up second 
patch series.) Thanks!

[ btw., how far away are you from having Kconfig selectable 64-bit
  paravirt support? Just curious :-) ]

	Ingo
