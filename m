Return-Path: <linux-kernel-owner+w=401wt.eu-S1760805AbXHHLBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760805AbXHHLBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 07:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbXHHLBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 07:01:10 -0400
Received: from ns2.suse.de ([195.135.220.15]:52846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbXHHLBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 07:01:09 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [PATCH] msleep() with hrtimers
References: <15327.1186166232@lwn.net>
	<20070807124009.9f6c2247.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 08 Aug 2007 13:55:28 +0200
In-Reply-To: <20070807124009.9f6c2247.akpm@linux-foundation.org>
Message-ID: <p73ps1ys0jz.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> 
> I'd be surprised if there was significant overhead - the maximum frequency
> at which msleep() can be called is 1000Hz.  We'd need an awful lot of
> overhead for that to cause problems, surely?

The bigger risk is probably to break drivers that rely on msleep(1) 
really being msleep( very long depending on HZ )

But the only way to find out is to try it.

-Andi

