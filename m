Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZD2JFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZD2JFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZD2JEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:04:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36412 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbZD2JEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:04:53 -0400
Date: Wed, 29 Apr 2009 11:04:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH/RFT 0/13] x86: unify vmlinux.lds
Message-ID: <20090429090418.GA26285@elte.hu>
References: <20090429073510.GA26386@uranus.ravnborg.org> <20090429075730.GD22129@elte.hu> <20090429082341.GA27386@uranus.ravnborg.org> <20090429083134.GA16680@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429083134.GA16680@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> [...] I have just processed them, cleaned up the changelogs, fixed 
> that minor detail with the attribution, applied them to 
> tip:x86/kbuild and started testing them - if initial tests look 
> good i'll push them out.

It held up (surprisingly) fine so far in testing so i've pushed them 
out. Feel free to send the other fixlets as delta patches, we can 
start testing them as well.

Alignment related bugs will need some more time to be found 
(randconfig tests need to find weird alignment and .config combos to 
trigger certain types of rare link script related bugs), but so far 
it all looks pretty promising already.

	Ingo
