Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbXGHSLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbXGHSLc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 14:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbXGHSLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 14:11:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbXGHSLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 14:11:23 -0400
To: avi@qumranet.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/20] SMP: Implement on_cpu()
References: <11838956891287-git-send-email-avi@qumranet.com>
	<11838956893094-git-send-email-avi@qumranet.com>
From: Andi Kleen <andi@firstfloor.org>
In-Reply-To: <11838956893094-git-send-email-avi@qumranet.com>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
Date: 08 Jul 2007 21:06:45 +0200
Message-ID: <p73lkdqzpdm.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> This defines on_cpu() which is similar to smp_call_function_single()
> except that it works if cpu happens to be the current cpu.  Can also be
> seen as a complement to on_each_cpu() (which also doesn't treat the
> current cpu specially).

I think it would be better to fix smp_call_function_single to just
handle this case transparently. There aren't that many callers yet because it is
fairly new.

-Andi
