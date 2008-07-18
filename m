Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbYGRPvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbYGRPvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYGRPv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:51:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57188 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYGRPv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:51:27 -0400
Date: Fri, 18 Jul 2008 17:51:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] intel_cacheinfo: fix use-after-free cache_kobject
Message-ID: <20080718155112.GW6875@elte.hu>
References: <20080715080903.GA22068@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715080903.GA22068@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0006]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Akinobu Mita <akinobu.mita@gmail.com> wrote:

> This avoids calling kobject_uevent() with cache_kobject that has 
> already been deallocated in an error path.

applied to tip/x86/urgent, thanks.

	Ingo
