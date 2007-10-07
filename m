Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbXJGQpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbXJGQpT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 12:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbXJGQpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 12:45:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50554 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbXJGQpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 12:45:04 -0400
Date: Sun, 7 Oct 2007 18:44:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH 1/2] Colored kernel output (run3)
Message-ID: <20071007164452.GA30429@elte.hu>
References: <Pine.LNX.4.64.0710062147370.20637@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0710062209390.20637@fbirervta.pbzchgretzou.qr> <20071007163824.GA30063@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071007163824.GA30063@elte.hu>
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


Jan,

> This patch makes it possible to give kernel messages a selectable 
> color. It can be chosen at compile time, overridden at boot time, and 
> changed at run time.

here's some (good) text footprint data:

with the feature disabled (which is the default), the text size 
difference with patch #1:

  vmlinux:
     text    data     bss     dec     hex filename
  7732358 1157269  401408 9291035  8dc51b vmlinux.before
  7732358 1157269  401408 9291035  8dc51b vmlinux.after

i.e. no overhead. Text size difference with patch #2:

  vmlinux:
     text    data     bss     dec     hex filename
  7732358 1157269  401408 9291035  8dc51b vmlinux.before
  7732374 1157269  401408 9291051  8dc52b vmlinux.after

16 bytes, or 0.0002% of the total text size. So there's in essence no 
text overhead to talk about. So the text overhead argument is a red 
herring.

	Ingo
