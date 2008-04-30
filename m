Return-Path: <linux-kernel-owner+w=401wt.eu-S1760780AbYD3Q3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780AbYD3Q3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756338AbYD3Q3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 12:29:09 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:6708 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbYD3Q3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 12:29:07 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] kmemcheck
References: <20080429203446.GA18314@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 30 Apr 2008 09:29:05 -0700
In-Reply-To: <20080429203446.GA18314@elte.hu> (Ingo Molnar's message of "Tue,
	29 Apr 2008 22:34:46 +0200")
Message-ID: <adazlrb8fxq.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Apr 2008 16:29:05.0825 (UTC) FILETIME=[4EE70110:01C8AADF]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >       kmemcheck: enable in the x86 Kconfig

This patch does:

 > +config KMEMCHECK
 > +	bool "kmemcheck: trap use of uninitialized memory"
 > +	depends on X86_32

So it's only possible to select kmemcheck on 32-bit builds, But you also
seem to have 64-bit stuff, eg

 >       kmemcheck: support for 64-bit
 >       kmemcheck: add missing pte_hidden() for x86-64

so is the Kconfig patch slightly out-of-date?

 - R.
