Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbXHSWGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbXHSWGb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbXHSWGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:06:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:59987 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbXHSWGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:06:21 -0400
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andreas Schwab <schwab@suse.de>, Alan Modra <alan@linuxcare.com.au>,
       David Mosberger-Tang <davidm@hpl.hp.com>
Subject: Re: sched.c: why -fno-omit-frame-pointer?
References: <20070819141732.GD32595@stusta.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 20 Aug 2007 01:00:17 +0200
In-Reply-To: <20070819141732.GD32595@stusta.de>
Message-ID: <p73r6lz1666.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@kernel.org> writes:
> 
> Is the -fno-omit-frame-pointer still required for some reason, or is 
> this a relict that could be removed?

It's needed so that the WCHAN /proc display can backtrace one
level up out of schedule()

-Andi
