Return-Path: <linux-kernel-owner+w=401wt.eu-S932221AbZJFRUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbZJFRUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbZJFRUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:20:52 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60303 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbZJFRUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:20:51 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4ACB7B4D.8080203@s5r6.in-berlin.de>
Date: Tue, 06 Oct 2009 19:15:57 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090926 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> So how about this?
> 
> It changes how CONFIG_LOCALVERSION_AUTO works, in the following trivial 
> way:
> 
>  - if it is set, things work the way they always have, and you get a 
>    extended kernel release like
> 
> 	2.6.32-rc3-00052-g0eca52a-dirty
> 
>  - but if it is _not_ set,
[...]
>    we append just "+", so you get a version number like
> 
> 	2.6.32-rc3+
[...]
> The "+" could be anything else, of course. The diff is pretty obvious, you 
> can argue about exactly _what_ you'd like to see as a suffix for "and then 
> some".

The "+" suffix is already in informal use with a different meaning.
It's customary to write "For feature XY, you need kernel 2.6.31+" as a
shorthand for "kernel 2.6.31 or any later release".
-- 
Stefan Richter
-=====-==--= =-=- --==-
http://arcgraph.de/sr/
