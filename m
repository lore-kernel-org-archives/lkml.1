Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbYJ1QAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbYJ1QAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbYJ1QAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:00:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56640 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbYJ1QAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:00:40 -0400
Date: Tue, 28 Oct 2008 17:00:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Jouni Malinen <jkmalinen@gmail.com>, Oliver Neukum <oliver@neukum.org>,
       Nicolas Bareil <nico@chdir.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, j@w1.fi
Subject: Re: [PATCH] x86, gart: fix gart detection for Fam11h CPUs
Message-ID: <20081028160026.GB27531@elte.hu>
References: <e785a1360810280207p1c162decs5a70b8915ea08476@mail.gmail.com> <1225206834-6189-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225206834-6189-1-git-send-email-joerg.roedel@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> The AMD Fam11h CPUs have a K8 northbridge. This northbridge is 
> different from other familys because it lacks GART support (as I 
> just learned). But the kernel implicitly expects a GART if it finds 
> an AMD northbridge. Fix this by removing the Fam11h northbridge id 
> from the scan list of K8 northbridges. This patch also changes the 
> message in the GART driver about missing K8 northbridges to tell 
> that the GART is missing which is the correct information in this 
> case.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/k8.c          |    1 -
>  arch/x86/kernel/pci-gart_64.c |    2 +-
>  2 files changed, 1 insertions(+), 2 deletions(-)

applied to tip/x86/urgent, thanks Joerg!

	Ingo
