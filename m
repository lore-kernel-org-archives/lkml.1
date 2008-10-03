Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYJCI5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYJCI5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 04:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYJCI5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 04:57:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35392 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbYJCI5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 04:57:13 -0400
Date: Fri, 3 Oct 2008 10:56:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Reserve FIRST_DEVICE_VECTOR in used_vectors
	bitmap.
Message-ID: <20081003085656.GB27551@elte.hu>
References: <48E0DA7C.5010403@canonical.com> <20080930095149.GA7557@elte.hu> <48E22165.7040907@canonical.com> <5201e28f0810020514g606e3ddbr26c2ed86693ced42@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5201e28f0810020514g606e3ddbr26c2ed86693ced42@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0037]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stefan Bader <stefan.bader@canonical.com> wrote:

> Hi Ingo,
> 
> I didn't see any follow up, so for clarification: there is nothing to 
> fix in tip but the bug is there in kernels between 2.6.24 and 2.6.27. 
> Could you push it to 2.6.27 and possibly to the stable trees?

it's too late for v2.6.27 - this bug permeates so many kernel versions 
that it's clearly not in the '2.6.27 regression' category. But it can be 
asked to be included in -stable after v2.6.27 is released.

	Ingo
