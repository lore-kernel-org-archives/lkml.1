Return-Path: <linux-kernel-owner+w=401wt.eu-S932450AbYD2OWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbYD2OWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760075AbYD2OQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:16:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47497 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759438AbYD2OQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:16:17 -0400
Date: Tue, 29 Apr 2008 16:15:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] toshiba: Use ioremap_cached
Message-ID: <20080429141559.GB26461@elte.hu>
References: <20080429142023.093bfba6@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429142023.093bfba6@core>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> The switch of ioremap to default to uncached doesn't break this driver
> but it does needlessly slow it down as BIOS space is cachable and this
> driver is quite happy scanning cached ROM space.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

i suspect this shouldnt go via x86.git but i've queued it up to track 
it. Is there an active maintainer for this file?

	Ingo
