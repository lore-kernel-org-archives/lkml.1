Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYGQR0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYGQR0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 13:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbYGQR0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 13:26:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44909 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbYGQR0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 13:26:05 -0400
Date: Thu, 17 Jul 2008 19:25:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH RESEND] xen: fix up config dependencies on PM
Message-ID: <20080717172542.GA28950@elte.hu>
References: <487D0BFE.1010401@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487D0BFE.1010401@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0012]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Xen save/restore needs bits of code enabled by PM_SLEEP, and PM_SLEEP
> depends on PM.  So make XEN_SAVE_RESTORE depend on PM and PM_SLEEP
> depend on XEN_SAVE_RESTORE.
>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

applied to tip/xen-64bit, thanks Jeremy.

	Ingo
