Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbYFRLlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbYFRLlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYFRLlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:41:01 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43505 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbYFRLlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:41:00 -0400
Date: Wed, 18 Jun 2008 13:40:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: mingo@redhat.com, arjan@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]include/linux/threads.h : Removes extra checking
	CONFIG_BASE_SMALL
Message-ID: <20080618114043.GA28838@elte.hu>
References: <b9df5fa10806180317k35e9861dr37bc346062924299@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa10806180317k35e9861dr37bc346062924299@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> In existing code for defining PID_MAX_DEFAULT and PID_MAX_LIMIT,a 
> check for CONFIG_BASE_SMALL has been made twice. This patch reduces an 
> extra checking.

hm, why should we do this change? The compiler will optimize away the 
check and it's cleaner without an extra #ifdef.

	Ingo
