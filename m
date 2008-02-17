Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbYBQTIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbYBQTIz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 14:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYBQTIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 14:08:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55105 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbYBQTIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 14:08:43 -0500
Date: Sun, 17 Feb 2008 20:08:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, ak@suse.de, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] x86: lds - Use THREAD_SIZE instead of numeric
	constant
Message-ID: <20080217190829.GJ19263@elte.hu>
References: <20080217151716.274134094@gmail.com> <20080217151925.402628615@gmail.com> <20080217185936.GB14588@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217185936.GB14588@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Sun, Feb 17, 2008 at 06:17:18PM +0300, Cyrill Gorcunov wrote:
> > Though we use PDA for regular task stack but that
> > is not acceptable for init_task wich is special
> > one. We still have to allocate init_task's stack
> > in that manner.
> 
> hpa had some comments about this particular alignment. If we keep the 
> alignmnet then Cyrill's patch looks good.

ok. I've picked up Cyrill's cleanup - can i add your acked-by line?

	Ingo
