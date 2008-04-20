Return-Path: <linux-kernel-owner+w=401wt.eu-S1759758AbYDTSvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbYDTSvj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbYDTSvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:51:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33797 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYDTSvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:51:31 -0400
Date: Sun, 20 Apr 2008 11:50:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: =?UTF-8?B?SsO2cm4=?= Engel <joern@logfs.org>, Willy Tarreau <w@1wt.eu>,
       Mark Lord <lkml@rtr.ca>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420115053.7151ef8d@laptopd505.fenrus.org>
In-Reply-To: <480B8932.1090308@firstfloor.org>
References: <20080420085104.GG1595@cs181133002.pp.htv.fi>
	<20080420103611.2c0d3519@the-village.bc.nu>
	<20080420104444.GI1595@cs181133002.pp.htv.fi>
	<87y778aezh.fsf@basil.nowhere.org>
	<20080420124717.GH8474@1wt.eu>
	<480B44C4.4060104@rtr.ca>
	<20080420133857.GB26536@1wt.eu>
	<480B50F1.8040309@firstfloor.org>
	<20080420164133.GB20694@logfs.org>
	<480B7B1E.7010707@firstfloor.org>
	<20080420174249.GC20694@logfs.org>
	<480B8932.1090308@firstfloor.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008 20:19:30 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> In theory if you e.g. convert a recursive algorithm
> to iterative you might save some cache foot print, but I don't
> think that really happens in kernel code.
> 

this is what Al did for the symlink recursion thing, and Jens did for the block layer...
so yes this conversion does happen for real.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
