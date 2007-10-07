Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbXJGVMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbXJGVMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 17:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbXJGVMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 17:12:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39241 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbXJGVMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 17:12:17 -0400
Date: Sun, 7 Oct 2007 23:11:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Oleg Verych <olecom@flower.upol.cz>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: Re: "Re: [PATCH 0/2] Colored kernel output (run2)" + "`Subject:'
	usage"
Message-ID: <20071007211154.GA27685@elte.hu>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr> <20071006195105.GE22435@flower.upol.cz> <20071006194820.GA30579@elte.hu> <20071006210349.GG22435@flower.upol.cz> <20071007060706.GA18768@elte.hu> <20071007111035.GO22435@flower.upol.cz> <20071007161255.GA22102@elte.hu> <470929D8.80003@keyaccess.nl> <20071007191309.GS10199@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071007191309.GS10199@1wt.eu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> I would say that while I'm not particularly fond of flashy colors 
> everywhere, I think that being able to use colors to indicate 
> particular actions in progress or conditions can be a good thing. RAID 
> errors, devices disabled due to command-line parameters, and general 
> anomalies which can cause a hang or panic a few line laters are worth 
> coloring. And I don't believe in userland's help here, because for 
> that type of messages, the indication should be returned immediately. 
> For instance, anyone who has experienced read errors on and IDE disk 
> knows that it can literally take hours/days to boot, after displaying 
> thousands of messages. Here, having the ability to see that no IRQ was 
> assigned or something like this could help.

Exactly. I'm also testing older distros quite regularly with new kernels 
and there's it's useful to have an impression of a kernel's output at a 
glance. Adding _any_ userspace change (even if i wanted to do it, which 
i dont) is out of question. So these are distinct, well-defined usecases 
that nobody has brought any coherent argument against yet. VGA isnt 
going away anytime soon, certainly not on my testboxes.

	Ingo
