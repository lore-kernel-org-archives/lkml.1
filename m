Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbYJ3XRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbYJ3XRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbYJ3XRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:17:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42891 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbYJ3XRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:17:36 -0400
Date: Fri, 31 Oct 2008 00:17:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix missing cpu_index initialisation
Message-ID: <20081030231723.GB1985@elte.hu>
References: <1225401217.19324.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225401217.19324.28.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> >From f49bbb826d8ec87609a63fb014af6aacb16aac38 Mon Sep 17 00:00:00 2001
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Wed, 29 Oct 2008 15:13:09 -0500
> Subject: [VOYAGER] x86: fix missing cpu_index initialisation
> 
> Ever since
> 
> commit 92cb7612aee39642d109b8d935ad265e602c0563
> Author: Mike Travis <travis@sgi.com>
> Date:   Fri Oct 19 20:35:04 2007 +0200
> 
>     x86: convert cpuinfo_x86 array to a per_cpu array
> 
> We've had an extra field in cpuinfo_x86 which is cpu_index.
> Unfortunately, voyager has never initialised this, although the only
> noticeable impact seems to be that /proc/cpuinfo shows all zeros for
> the processor ids.
> 
> Anyway, fix this by initialising the boot CPU properly and setting the
> index when the secondaries update.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
> 
> Depends on [VOYAGER] x86: add ability to test for boot CPU

applied both to tip/x86/urgent:

 6b5496e: x86/voyager: fix missing cpu_index initialisation
 3b25aec: x86/voyager: fix compile breakage caused by dc1e35c6e95e8923cf1d35104

thanks James,

	Ingo
