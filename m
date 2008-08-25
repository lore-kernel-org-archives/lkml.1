Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbYHYTBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbYHYTBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 15:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYHYTB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 15:01:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53302 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670AbYHYTB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 15:01:27 -0400
Date: Mon, 25 Aug 2008 21:01:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: objcopy version test for local symbols
Message-ID: <20080825190103.GA24029@elte.hu>
References: <20080825130117.33fe34bc.sfr@canb.auug.org.au> <20080825060934.GB14993@elte.hu> <alpine.DEB.1.10.0808251434000.23923@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808251434000.23923@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> From: Steven Rostedt <srostedt@redhat.com>
> Subject: ftrace: objcopy version test for local symbols
> 
> The --globalize-symbols option came out in objcopy version 2.17.
> If the kernel is being compiled on a system with a lower version of
> objcopy, then we can not use the globalize / localize trick to
> link to symbols pointing to local functions.
> 
> This patch tests the version of objcopy and will only use the trick
> if the version is greater than or equal to 2.17. Otherwise, if an
> object has only local functions within a section, it will give a
> nice warning and recommend the user to upgrade their objcopy.
> 
> Leaving the symbols unrecorded is not that big of a deal, since the
> mcount record method changes the actual mcount code to be a simple
> "ret" without recording registers or anything.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

applied to tip/tracing/ftrace, also have integrated it into 
auto-ftrace-next. (without much testing - i hope it goes well)

	Ingo
