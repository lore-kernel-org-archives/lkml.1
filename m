Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbXIUUOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbXIUUOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763450AbXIUUNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:13:50 -0400
Received: from ns2.suse.de ([195.135.220.15]:59391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761455AbXIUUNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:13:49 -0400
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] bnx2: factor out gzip unpacker
References: <200709211201.24475.vda.linux@googlemail.com>
	<200709211803.55554.vda.linux@googlemail.com>
	<20070921.104912.41646795.davem@davemloft.net>
	<200709211905.23946.vda.linux@googlemail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 21 Sep 2007 22:13:46 +0200
In-Reply-To: <200709211905.23946.vda.linux@googlemail.com>
Message-ID: <p73ps0b93ph.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko <vda.linux@googlemail.com> writes:
> 
> I plan to use gzip compression on following drivers' firmware,
> if patches will be accepted:
> 
>    text    data     bss     dec     hex filename
>   17653  109968     240  127861   1f375 drivers/net/acenic.o
>    6628  120448       4  127080   1f068 drivers/net/dgrs.o
>          ^^^^^^

Just change the makefiles to always install gzip'ed modules
modutils knows how to unzip them on the fly.

That will catch all the firmware and all the other code too.

-Andi
