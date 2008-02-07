Return-Path: <linux-kernel-owner+w=401wt.eu-S1761406AbYBGOa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761406AbYBGOa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 09:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932174AbYBGOaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 09:30:14 -0500
Received: from styx.suse.cz ([82.119.242.94]:53661 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761070AbYBGOaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 09:30:12 -0500
Date: Thu, 7 Feb 2008 15:30:11 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Hugh Dickins <hugh@veritas.com>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Document randomize_va_space and CONFIG_COMPAT_BRK (was
 Re: [PATCH 2/2] ASLR: add possibility for more fine-grained	tweaking)
In-Reply-To: <20080206231040.GA6225@elte.hu>
Message-ID: <Pine.LNX.4.64.0802071525520.30955@jikos.suse.cz>
References: <Pine.LNX.4.64.0802061438150.30955@jikos.suse.cz>
 <Pine.LNX.4.64.0802061442300.30955@jikos.suse.cz> <20080206134959.GA25689@elte.hu>
 <Pine.LNX.4.64.0802061650230.30955@jikos.suse.cz> <20080206231040.GA6225@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008, Ingo Molnar wrote:

> i'm wondering about the following detail: i guess on 64-bit x86 kernels 
> we could default to !CONFIG_COMPAT_BRK? In 1997 there was no 64-bit x86. 
> Maybe for compat 32-bit binaries we could keep it off, but always do it 
> for 64-bit binaries.

So what do you think is proper behavior in situation when 
CONFIG_COMPAT_BRK=N on 64bit kernel, and 32bit-binary is loaded in 32bit 
emulation?

We can either leave the brk as-is, but that is in contradiction to user 
explictly specifying CONFIG_COMPAT_BRK=N. Is this what you propose?

Or we can randomize brk start in such situation, but that is the behavior 
we currently automatically have due to CONFIG_COMPAT_BRK=N, so no change 
is needed.

Thanks,

-- 
Jiri Kosina
SUSE Labs
