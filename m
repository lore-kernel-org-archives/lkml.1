Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYEaQj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYEaQj4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 12:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbYEaQjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 12:39:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56740 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbYEaQjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 12:39:47 -0400
Date: Sat, 31 May 2008 18:39:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Hladky <hladky.jiri@googlemail.com>
Cc: linux-kernel@vger.kernel.org, mj@atrey.karlin.mff.cuni.cz, x86@kernel.org
Subject: Re: Bug in arch/i386/lib/delay.c file, delay_loop function
Message-ID: <20080531163936.GC22607@elte.hu>
References: <900048340805300815u57af94b0i3971b22a9d154d1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <900048340805300815u57af94b0i3971b22a9d154d1f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0398]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Hladky <hladky.jiri@googlemail.com> wrote:

> Hi all,
> 
> when trying to understand how Bogomips are implemented I have found 
> bug in arch/i386/lib/delay.c file, delay_loop function

very interesting! Could you send a kernel patch for it please:

  diff -up arch/x86/lib/delay_32.c.orig arch/x86/lib/delay_32.c

	Ingo
