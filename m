Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbZJYQiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbZJYQiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 12:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbZJYQip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 12:38:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46260 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZJYQio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 12:38:44 -0400
Date: Sun, 25 Oct 2009 17:38:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH tip/x86/entry] Fix user return notifier build
Message-ID: <20091025163844.GF20391@elte.hu>
References: <1256473485-23109-1-git-send-email-avi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256473485-23109-1-git-send-email-avi@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> When CONFIG_USER_RETURN_NOTIFIER is set, we need to link
> kernel/user-return-notifier.o.
> 
> Signed-off-by: Avi Kivity <avi@redhat.com>
> ---
>  kernel/Makefile |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Applied, thanks.

I suspect you want to pull x86/entry into kvm.git? The base patch itself 
has not caused any trouble.

	Ingo
