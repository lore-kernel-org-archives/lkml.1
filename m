Return-Path: <linux-kernel-owner+w=401wt.eu-S1761261AbZAWSeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261AbZAWSeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 13:34:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbZAWSdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 13:33:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36153 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbZAWSdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 13:33:55 -0500
Date: Fri, 23 Jan 2009 19:33:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Petr =?utf-8?Q?Tit=C4=9Bra?= <P.Titera@century.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Build error on x86
Message-ID: <20090123183343.GB5984@elte.hu>
References: <497A09C4.2050500@century.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <497A09C4.2050500@century.cz>
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


* Petr Titěra <P.Titera@century.cz> wrote:

> Hello,
>
> i've got this during series of repeated randconfig errors.
>
> CC arch/x86/lguest/boot.o
> In file included from  
> /home/century.cz/owl/scm/linux-2.6/arch/x86/include/asm/smp.h:19,
> from include/linux/smp.h:13,
> from include/linux/irq.h:12,
> from arch/x86/lguest/boot.c:50:
> /home/century.cz/owl/scm/linux-2.6/arch/x86/include/asm/thread_info.h:35: 
> error: field restart_blockâ has incomplete type
> make[1]: *** [arch/x86/lguest/boot.o] Error 1
> make: *** [arch/x86/lguest] Error 2
>
> Config and full build log attached. Is randconfig supposed to give valid  
> config every time?

hm, i cannot reproduce your build failure with latest -git 
(v2.6.29-rc2-13-gf3b8436), using your config-1232519930.

Can you reproduce with latest -git? (your config suggests you are still 
testing with .29-rc1) If it still occurs, which compiler version are you 
using?

	Ingo
