Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbYIIL2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbYIIL2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 07:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYIIL16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 07:27:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45717 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbYIIL15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 07:27:57 -0400
Date: Tue, 9 Sep 2008 13:27:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alex Nixon <alex.nixon@citrix.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] Xen: Fix pte unpin BUG when !CONFIG_SMP
Message-ID: <20080909112744.GA9762@elte.hu>
References: <1220959508-13806-1-git-send-email-alex.nixon@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220959508-13806-1-git-send-email-alex.nixon@citrix.com>
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


* Alex Nixon <alex.nixon@citrix.com> wrote:

> We still need to pin PTEs, even if there are no PTE locks.  Otherwise we'll BUG whenever there aren't 
> PTE locks (i.e. whenever NR_CPUS < CONFIG_SPLIT_PTLOCK_CPUS), as we try to unpin PTEs which were 
> never pinned in the first place.
> 
> Signed-off-by: Alex Nixon <alex.nixon@citrix.com>

applied to tip/x86/xen, thanks Alex.

	Ingo
