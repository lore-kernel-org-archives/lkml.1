Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYFHNOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYFHNOa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 09:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752620AbYFHNOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 09:14:21 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61931 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751472AbYFHNOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 09:14:20 -0400
Date: Sun, 8 Jun 2008 14:13:37 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] x86: NMI watchdog downgrade changes
In-Reply-To: <20080608081826.GA20033@elte.hu>
Message-ID: <Pine.LNX.4.55.0806081401130.15673@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0806060311510.2875@cliff.in.clinika.pl>
 <20080608081826.GA20033@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2008, Ingo Molnar wrote:

> applied, thanks Maciej. This series resolved another nmi_watchdog 
> related boot failure i found today.

 Well, APIC code starts breaking in an unobvious way when you start
throwing random kernel parameters at it.  Which is the reason I am so
hesitant about adding more of them, especially the obscurer ones.  Nobody
tests them seriously beyond the original submission, which actually may
not cover all the important cases either, and then bit rot accumulates.

 Have you tried "nolapic" on an SMP system, BTW?

  Maciej
