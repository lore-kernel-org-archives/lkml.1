Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbYEHCJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbYEHCJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 22:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbYEHCJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 22:09:40 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51861 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756392AbYEHCJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 22:09:39 -0400
Date: Wed, 7 May 2008 19:08:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Adrian Bunk <bunk@kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [PATCH] x86: enable PAT support on AMD Duron model 7
Message-ID: <20080507190848.43baaa7f@infradead.org>
In-Reply-To: <48225F95.3020205@keyaccess.nl>
References: <48210A71.1060409@keyaccess.nl>
	<86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>
	<20080507124650.GD29935@cs181133002.pp.htv.fi>
	<alpine.LFD.1.10.0805072122270.3318@apollo.tec.linutronix.de>
	<48221AE3.6020602@keyaccess.nl>
	<482233F0.7040000@zytor.com>
	<48224318.8020209@keyaccess.nl>
	<48224361.5080102@zytor.com>
	<48224507.8010102@keyaccess.nl>
	<alpine.LFD.1.10.0805071716060.3024@woody.linux-foundation.org>
	<48224930.9030901@keyaccess.nl>
	<48225DEC.2030502@keyaccess.nl>
	<48225F95.3020205@keyaccess.nl>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2008 04:04:05 +0200
Rene Herman <rene.herman@keyaccess.nl> wrote:

> On 08-05-08 03:57, Rene Herman wrote:
> 
> > Okay, so how's this? Seem to work well for me and makes me happy.
> > Only tested on UP.
> 
> With this on top, I'm ecstatic:
> 
>   x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> 
> 
> x86: enable PAT support on AMD Duron model 7
> 
> PAT support seems to work well on AMD Duron model 7. Enable it.

have you read the errata sheets for this one?
have you tried various cachability/mtrr combinations (with a new
enough X)?

just booting doesn't say much if the feature won't just randomly
tripple fault later on
