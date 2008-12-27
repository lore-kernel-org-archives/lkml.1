Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbYL0Ire@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbYL0Ire (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 03:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbYL0IrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 03:47:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60497 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbYL0IrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 03:47:25 -0500
Date: Sat, 27 Dec 2008 09:47:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Mike Frysinger <vapier@gentoo.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
Message-ID: <20081227084708.GA16077@elte.hu>
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <20081227071208.GB27736@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227071208.GB27736@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Sat, Dec 27, 2008 at 01:50:04AM -0500, Mike Frysinger wrote:
> > Use __asm__/__inline__ rather than asm/inline for all the functions
> > exported to userspace.
> 
> I will imagine that we will see cleanup patches converting
> these back to inline/asm.
> How about doing this conversion as part of the headers_install.pl
> script so we know it is always correct?
> 
> Then we can keep the familiar inline/asm in the kernel headers
> and always use the correct __asm__, __inline__ version for our
> exported headers.

or name it __asm__exported__ to make sure it isnt cleaned up away.

	Ingo
