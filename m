Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbYKWS70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbYKWS70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 13:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbYKWS7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 13:59:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48948 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbYKWS7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 13:59:15 -0500
Date: Sun, 23 Nov 2008 19:59:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hannes Eder <hannes@hanneseder.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] x86: boot - fix sparse warnings
Message-ID: <20081123185907.GC21106@elte.hu>
References: <154e089b0811231037l18d4d8erce62eb4e77e28b10@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154e089b0811231037l18d4d8erce62eb4e77e28b10@mail.gmail.com>
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


* Hannes Eder <hannes@hanneseder.net> wrote:

> Fix this sparse warnings:
> 
> arch/x86/boot/video.c:233:3: warning: symbol 'saved' was not declared.
> Should it be static?
> arch/x86/boot/video-vga.c:37:13: warning: symbol 'video_vga' was not
> declared. Should it be static?
> 
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  arch/x86/boot/video-vga.c |    4 ++--
>  arch/x86/boot/video.c     |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)

applied to tip/x86/sparse-fixes, thanks Hannes!

	Ingo
