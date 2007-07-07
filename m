Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbXGGBnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbXGGBnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 21:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbXGGBnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 21:43:22 -0400
Received: from smtpout.mac.com ([17.250.248.186]:58154 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbXGGBnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 21:43:22 -0400
In-Reply-To: <25263529-06F1-421B-95B9-5D6CBE8CDB5A@cs.uiowa.edu>
References: <200707051251.52891.vda.linux@googlemail.com> <20070705143419.f214f5b2.akpm@linux-foundation.org> <6F17353B-D428-462B-B318-2FDEC11E8D66@cs.uiowa.edu> <9a8748490707060821m50e53fc2uba2552ea2e0d07a2@mail.gmail.com> <25263529-06F1-421B-95B9-5D6CBE8CDB5A@cs.uiowa.edu>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <C60FF4E3-843B-458C-8BD8-F38896FD8373@mac.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Denis Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH 2/2] vsprintf.c: optimizing, part 2: base 10 conversion speedup, v2
Date: Fri, 6 Jul 2007 21:43:08 -0400
To: "Douglas W. Jones" <jones@cs.uiowa.edu>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 06, 2007, at 11:53:40, Douglas W. Jones wrote:
> This implies my bemused permission to freely use anything developed  
> from my tutorials on the web, not my endorsement of what was done  
> with that material.  I say bemused because it seems far fetched to  
> claim that I have any ownership interest in this material.  The  
> author of a tutorial text clearly owns the tutorial organization  
> and presentation of that text, but to claim ownership of the ideas  
> being taught is strange.

The Signed-off-by stuff is sometimes one of those sad but easy little  
things we do to avoid anybody getting stuck in court over patent/ 
copyright later on, and to be able to prove that our GPLed stuff is  
actually ours to GPL.  As it's an implementation of a simple modular  
base-2 math concept I don't see any reason why you need to sign-off;  
the only person who needs to do so is Denis Vlasenko (the person who  
actually wrote the specific copyrighted code).  The real practical  
use is to be able to follow the chain of "I got this from [...]" back  
to its original source, which is especially valuable in the presence  
of scum like SCO (they claimed some of Linus' code as their own).

So I wouldn't worry about it, the only person who really needs to do  
anything is Denis.

Cheers,
Kyle Moffett
