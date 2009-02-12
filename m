Return-Path: <linux-kernel-owner+w=401wt.eu-S1759494AbZBLQve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494AbZBLQve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 11:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757311AbZBLQvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 11:51:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40409 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173AbZBLQvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 11:51:24 -0500
Date: Thu, 12 Feb 2009 10:50:34 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@tglx.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>
Subject: Re: [patch] irq threading: fix PF_HARDIRQ definition
Message-ID: <20090212105034.586c53d1@torg>
In-Reply-To: <20090212084222.GA32091@elte.hu>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	<20090211205533.329cea1c@torg>
	<20090212083850.GA29995@elte.hu>
	<20090212084222.GA32091@elte.hu>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n1CGpcwM022927

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Thu, 12 Feb 2009 09:42:22 +0100
Ingo Molnar <mingo@elte.hu> wrote:
> 
> Anyway, my fix should solve this. Do you still see the lockup under X? (make
> sure you also have the IPI fix applied, see the patch in this same thread.)

That did it (the IPI patch and the redefinition). I'm up with:

$ uname -a
Linux torg 2.6.29-rc4-rt1-tip #51 SMP PREEMPT RT Thu Feb 12 09:40:06
CST 2009 x86_64 x86_64 x86_64 GNU/Linux

Thanks, I'll do some latency testing on my test boxes next...

Clark
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkmUU2gACgkQHyuj/+TTEp3c7wCgjnQuYgoLmGOmq26a2T198eh/
KdgAnjmX+cqwxYAtzaHeMH6/nO6MNuUH
=NHh/
-----END PGP SIGNATURE-----
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
