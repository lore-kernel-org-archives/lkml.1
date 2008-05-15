Return-Path: <linux-kernel-owner+w=401wt.eu-S1761474AbYEOWnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbYEOWnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 18:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbYEOWmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 18:42:54 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:56064 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbYEOWmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 18:42:53 -0400
Message-ID: <482CBCCB.8070101@keyaccess.nl>
Date: Fri, 16 May 2008 00:44:27 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>, geert@linux-m68k.org,
       zippel@linux-m68k.org, schwab@suse.de, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH] init - fix building bug and potential buffer overflow
References: <20080514154402.GF6902@cvg> <20080515105803.7c9ab8c7.akpm@linux-foundation.org> <20080515180528.GC7481@cvg> <Pine.LNX.4.64.0805152132530.22059@anakin> <aa79d98a0805151322s20a2bb34x4491bcacfcef310@mail.gmail.com> <20080515134928.83b2d948.akpm@linux-foundation.org> <alpine.LFD.1.10.0805151406030.3019@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805151406030.3019@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15-05-08 23:15, Linus Torvalds wrote:

> Talking about cleanups, why the *hell* does print_fn_descriptor_symbol() 
> take an "unsigned long", when every single user would want to give it a 
> pointer?
> 
> Would somebody please want to move that cast into the macro (or better 
> yet, make it an inline function that takes a 'void *'), and remove all the 
> casts from the callers?

[ ... ]

> +		print_fn_descriptor_symbol("calling  %s()\n",
> +				(unsigned long) call);


And while that person is at it, could he or she please remove the silly 
() from the "foo+0x0/0x1234()" (or the "foo+0x0/0x1234 [bar]()" or the 
"0x12345678()").

Rene.
