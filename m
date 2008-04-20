Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbYDTRPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbYDTRPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 13:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYDTRPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 13:15:12 -0400
Received: from qmta07.westchester.pa.mail.comcast.net ([76.96.62.64]:38690
	"EHLO QMTA07.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753160AbYDTRPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 13:15:11 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Apr 2008 13:15:11 EDT
X-Authority-Analysis: v=1.0 c=1 a=Q8Gs9bZg81cupfBjvhMA:9
 a=0Hgyp1d33VZ9vveNF3AA:7 a=uVxzsZc6kX8zZpzCKzFreaTV0zUA:4 a=LY0hPdMaydYA:10
Date: Sun, 20 Apr 2008 09:59:39 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Oliver Pinter <oliver.pntr@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com
Subject: Re: x86: 4kstacks default
Message-ID: <20080420165939.GB7963@puku.stupidest.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <6101e8c40804190735g17f1e0bj25c2bc0e2a6eac26@mail.gmail.com> <20080419151911.GB1595@cs181133002.pp.htv.fi> <480AA2B9.10305@sandeen.net> <20080420074228.GE1595@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080420074228.GE1595@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 10:42:28AM +0300, Adrian Bunk wrote:

> We are going from 6k to 4k.

6k?

> Why should users have to poke with such deeply internal things?
> That doesn't sound right.

they shouldn't, so a 4k default is a problem for them

> Excessive stack usage in the kernel is considered to be a bug.

define excessive

> We should identify and fix all remaining problems (if any).

let's see your patches then
