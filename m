Return-Path: <linux-kernel-owner+w=401wt.eu-S1751461AbZIZHTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbZIZHTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 03:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbZIZHTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 03:19:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:44698 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZIZHTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 03:19:39 -0400
Date: Sat, 26 Sep 2009 09:20:01 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Aneurin Price <aneurin.price@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regression: kernels since 2.6.26 are unusably slow
Message-ID: <20090926092001.085bd86c@infradead.org>
In-Reply-To: <501db8660909251509i3eb6cb20i74337928e0708410@mail.gmail.com>
References: <501db8660909251509i3eb6cb20i74337928e0708410@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009 23:09:32 +0100
Aneurin Price <aneurin.price@gmail.com> wrote:

> Hi,
> Every kernel since 2.6.26 has been unusably slow for me - to the
> extent that I initially thought they were hanging on boot. Exactly
> how bad it is seems to vary, but it could take several minutes to
> boot, and then another minute or two to log in (with bash pegging the
> CPU as it loads). Everything seems to need vastly more CPU time than
> usual - it feels a little like I'm using a 486.

means part of memory is uncached.

> 
> I've bisected the problem down to commit
> 42651f15824d003e8357693ab72c4dbb3e280836 (x86: fix trimming e820 with
> MTRR holes). Having basically no idea what that means, I thought I'd
> try building a kernel with MTRRs disabled, to see if that would make
> any difference, but no joy.

b0rked MTRRs will do that to you ;-)

> 
> Can anyone give me some idea of where to go next, or let me know what
> further information I should provide?
> 

one thing to try is enabling CONFIG_MTRR_SANITIZER as config option;
that lets linux rewrite all MTRRs to see if it can puzzle a combination
together that fits all your memory...

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
