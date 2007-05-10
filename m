Return-Path: <linux-kernel-owner+w=401wt.eu-S1761946AbXEJWeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761946AbXEJWeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbXEJWeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:34:25 -0400
Received: from mail.suse.de ([195.135.220.2]:45969 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954AbXEJWeY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:34:24 -0400
To: Maxim Uvarov <muvarov@ru.mvista.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Performance Stats: Kernel patch
References: <20070510171947.19532.70784.stgit@localhost.localdomain>
From: Andi Kleen <andi@firstfloor.org>
Date: 11 May 2007 01:31:44 +0200
In-Reply-To: <20070510171947.19532.70784.stgit@localhost.localdomain>
Message-ID: <p731whofe73.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Uvarov <muvarov@ru.mvista.com> writes:
> 
> This data is useful for detecting hyperactivity
> patterns between processes.

You need a lot better rationale to slow down these important
fast paths. Particularly the syscall path is very hot.

Is this something that is really generally useful? The context
switch counters might be occasionally useful, but strace can
you just give the syscall count anyways. Still not sure 
it really should go into the standard kernel. Perhaps just keep it 
as a systemtap script?

-Andi
