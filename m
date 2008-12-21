Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbYLUTxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbYLUTxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 14:53:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbYLUTx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 14:53:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52161 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbYLUTxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 14:53:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #12156] v2.6.28-rc2: x86_32 relocation regression?
Date: Sun, 21 Dec 2008 20:53:29 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "the arch/x86 maintainers" <x86@kernel.org>
References: <vYigq6XkyUN.A.E1H.7ZYTJB@chimera> <vy-yJy0f3YP.A.yhB.qaYTJB@chimera> <20081221081406.GB4773@elte.hu>
In-Reply-To: <20081221081406.GB4773@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812212053.29463.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 21 of December 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12156
> > Subject		: v2.6.28-rc2: x86_32 relocation regression?
> > Submitter	: Vegard Nossum <vegard.nossum@gmail.com>
> > Date		: 2008-11-24 21:19 (27 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122756158220966&w=4
> 
> not really a regression but a long-standing inconvenience/bug of the debug 
> symbols of relocatable kernels. (ever since relocatable kernels were added 
> in '06 or so.) Nevertheless we queued up a revert of the defconfig change 
> for .29, to not expose it in the defconfig:
> 
>  f269b07: x86: revert CONFIG_RELOCATABLE=y defconfig change
> 
> so i think it can be taken off the regressions list.

Dropped.

Thanks,
Rafael
