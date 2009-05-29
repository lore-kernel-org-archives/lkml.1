Return-Path: <linux-kernel-owner+w=401wt.eu-S1760002AbZE2PWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbZE2PWC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 11:22:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZE2PVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 11:21:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47598 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbZE2PVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 11:21:52 -0400
Date: Fri, 29 May 2009 11:21:53 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: wuzhangjin@gmail.com
cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Wu Zhangjin <wuzj@lemote.com>, Ralf Baechle <ralf@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
Subject: Re: [PATCH v2 3/6] add an endian argument to
 scripts/recordmcount.pl
In-Reply-To: <6f4f65069c0ace1f0cffd9ce152f226f09edad9b.1243604390.git.wuzj@lemote.com>
Message-ID: <alpine.DEB.2.00.0905291120190.31247@gandalf.stny.rr.com>
References: <cover.1243604390.git.wuzj@lemote.com> <6f4f65069c0ace1f0cffd9ce152f226f09edad9b.1243604390.git.wuzj@lemote.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 29 May 2009, wuzhangjin@gmail.com wrote:

> From: Wu Zhangjin <wuzj@lemote.com>
> 
> mips architecture need this argument to handle big/little endian
> differently.

Actually, I was thinking that you add this before adding the mips code. 
That way we don't add a broken mips code first.

So could you swap this with patch 2?

-- Steve

> 
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
