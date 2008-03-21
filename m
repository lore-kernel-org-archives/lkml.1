Return-Path: <linux-kernel-owner+w=401wt.eu-S1757179AbYCUMie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbYCUMie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 08:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbYCUMi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 08:38:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41817 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754611AbYCUMiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 08:38:25 -0400
Date: Fri, 21 Mar 2008 13:38:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Willy Tarreau <w@1wt.eu>, Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: K8, GEODE_LX, CRUSOE, EFFICEON and CORE2 support
	the cmovxx instructions.
Message-ID: <20080321123810.GM25225@elte.hu>
References: <20080312200128.GA24983@mailshack.com> <47DABEFB.3050704@goop.org> <1205523826.7441.1242464129@webmail.messagingengine.com> <20080314195520.GV2522@one.firstfloor.org> <1205530409.27413.1242484373@webmail.messagingengine.com> <20080315191946.GA21817@mailshack.com> <47DC2F08.9080004@zytor.com> <1205615192.29139.1242596503@webmail.messagingengine.com> <20080315211125.GB13012@1wt.eu> <20080316131656.GA29207@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080316131656.GA29207@mailshack.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0428]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> x86: K8, GEODE_LX, CRUSOE, EFFICEON and CORE2 support CMOV.
> 
> Instead of summing up the cpu's that have support for the
> cmov instruction, sum up the cpu's that don't.
> 
> GEODE_LX has no entry in arch/x86/Makefile_32.cpu, so it did not get 
> any -march or -mtune arguments at all. I quite arbitrarily added 
> -march=i686 -mtune=pentium-mmx. This way gcc is allowed to use cmov 
> instructions.

thanks, applied.

	Ingo
