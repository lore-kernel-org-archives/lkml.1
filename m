Return-Path: <linux-kernel-owner+w=401wt.eu-S1765355AbZAQQ1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765355AbZAQQ1e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763023AbZAQQ1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:27:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50066 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762861AbZAQQ1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:27:04 -0500
Date: Sat, 17 Jan 2009 17:26:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofile: fix uninitialized use of struct op_entry
Message-ID: <20090117162657.GE10825@elte.hu>
References: <1232208807-26699-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232208807-26699-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3900]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> In case of losing samples struct op_entry could have been used
> uninitialized causing e.g. a wrong preemtion count or NULL pointer
> access. This patch fixes this.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  drivers/oprofile/cpu_buffer.c |    5 +++++
>  drivers/oprofile/cpu_buffer.h |    7 +++++++
>  2 files changed, 12 insertions(+), 0 deletions(-)

applied to tip/core/urgent, thanks Robert!

	Ingo
