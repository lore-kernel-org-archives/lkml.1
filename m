Return-Path: <linux-kernel-owner+w=401wt.eu-S1762263AbYFDTy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762263AbYFDTy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758825AbYFDTyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:54:19 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48199 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbYFDTyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:54:19 -0400
Date: Wed, 4 Jun 2008 13:54:18 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] __down_common: use signal_pending_state()
Message-ID: <20080604195418.GK3549@parisc-linux.org>
References: <20080604170906.GA10276@tv-sign.ru> <20080604173633.GI3549@parisc-linux.org> <20080604180858.GB10295@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604180858.GB10295@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 10:08:58PM +0400, Oleg Nesterov wrote:
> Actually, I don't understand why __down_common/__mutex_lock_common are inlines,
> perhaps it is better to shrink .text instead.

I believe Ingo did extensive benchmarking to determine that the current
situation with mutex_lock_common is the best one.  I didn't, I assumed
that following Ingo's lead would be the best idea.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
