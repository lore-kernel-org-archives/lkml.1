Return-Path: <linux-kernel-owner+w=401wt.eu-S1752612AbXA2Vbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbXA2Vbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 16:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbXA2Vbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 16:31:37 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48978 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbXA2Vbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 16:31:36 -0500
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20070127181759.eb7fe5e8.akpm@osdl.org>
References: <20070123211159.178138000@localhost.localdomain>
	 <20070127181759.eb7fe5e8.akpm@osdl.org>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 13:31:30 -0800
Message-Id: <1170106290.1296.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-01-27 at 18:17 -0800, Andrew Morton wrote:
> On Tue, 23 Jan 2007 22:00:55 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > This is a full replacement queue for the high resolution timer / dynamic 
> > ticks implemementation in -mm.
> 
> The Vaio broke again.  Seems to hang permanently the first time it tries to
> sleep.  The cursor doesn't flash.  Adding "clock=pit" doesn't fix it.  I'm
> disinclined to bisect it since the patch series fails to compile at
> practically all bisections points.
> 
> I'll drop all the patches, which means I drop John's vsyscall patches and
> his x86_64 conversion as well.

"He's got a bug!"
What's his bug got to do with me?
"He's got a bug!"
I ain't trying to hear that, see?

But seriously (the above might be too obscure of a reference :), my
x86_64 GTOD patches were against vanilla and were not dependent on the
HRT patches. There were a few merge/fixup patches in your tree, but I
don't recall many of them being really interleaved w/ the HRT code. I'm
I missing or forgetting some bit?

Should I just revive the old 2.6.20-rc4-mm1 patches against your current
tree and re-submit? Or should the HRT bits get settled first?

"ain't no future in fronting"
-john


