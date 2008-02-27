Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbYB0PRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbYB0PRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 10:17:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbYB0PRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 10:17:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39409 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYB0PRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:17:02 -0500
Date: Wed, 27 Feb 2008 16:16:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] elfcore-compat fix uid/gid types
Message-ID: <20080227151611.GF21610@elte.hu>
References: <20080226212058.6161426F9A4@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226212058.6161426F9A4@magilla.localdomain>
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


* Roland McGrath <roland@redhat.com> wrote:

> I overlooked the difference between __kernel_uid_t and uid_t when 
> defining struct compat_elf_prpsinfo.  The result is a regression in 
> 32-bit core dumps on x86_64, where the NT_PRPSINFO note has the wrong 
> size and layout. This patch fixes it.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
