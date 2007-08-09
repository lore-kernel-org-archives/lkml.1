Return-Path: <linux-kernel-owner+w=401wt.eu-S966837AbXHIRFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966837AbXHIRFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934432AbXHIRFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:05:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53021 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765953AbXHIRE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:04:59 -0400
Date: Thu, 9 Aug 2007 10:04:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@googlemail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       linux-mm@kvack.org
Subject: Re: 2.6.23-rc2-mm1
Message-Id: <20070809100438.386010ac.akpm@linux-foundation.org>
In-Reply-To: <46BB3E92.5040007@googlemail.com>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
	<46BB3499.5090803@googlemail.com>
	<46BB3E92.5040007@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Aug 2007 18:19:30 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> This might be related. The kernel is tainted because I hit
> kernel BUG at /home/devel/linux-mm/mm/swap_state.c:78!

umm, possibly.  If we went BUG while holding a spinlock then sure, 
a future lockup is pretty much inevitable.  But the lockdep
uninitialised-lock complaint is a bit of a surprise.

Can you please retest with Hugh's fix applied?
