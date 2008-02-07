Return-Path: <linux-kernel-owner+w=401wt.eu-S932080AbYBGJt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbYBGJt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYBGJtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:49:46 -0500
Received: from styx.suse.cz ([82.119.242.94]:44902 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759201AbYBGJtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:49:43 -0500
Date: Thu, 7 Feb 2008 10:49:41 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Hugh Dickins <hugh@veritas.com>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Document randomize_va_space and CONFIG_COMPAT_BRK (was
 Re: [PATCH 2/2] ASLR: add possibility for more fine-grained	tweaking)
In-Reply-To: <20080206231040.GA6225@elte.hu>
Message-ID: <Pine.LNX.4.64.0802071048230.30955@jikos.suse.cz>
References: <Pine.LNX.4.64.0802061438150.30955@jikos.suse.cz>
 <Pine.LNX.4.64.0802061442300.30955@jikos.suse.cz> <20080206134959.GA25689@elte.hu>
 <Pine.LNX.4.64.0802061650230.30955@jikos.suse.cz> <20080206231040.GA6225@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008, Ingo Molnar wrote:

> > Still, I think that we want the Documentation/sysctl/kernel.txt part 
> > of my patch probably. Updated patch below.
> thanks, applied.

.. and I have just noticed that my patch was by mistake missing signoff. 
Could you please add 

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

to the patch in your tree? Thanks.

> i'm wondering about the following detail: i guess on 64-bit x86 kernels 
> we could default to !CONFIG_COMPAT_BRK? In 1997 there was no 64-bit x86. 
> Maybe for compat 32-bit binaries we could keep it off, but always do it 
> for 64-bit binaries.

That actually makes sense, thanks. I will send you a patch.

Thanks,

-- 
Jiri Kosina
SUSE Labs
