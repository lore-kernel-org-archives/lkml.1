Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbXFYBqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbXFYBqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 21:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbXFYBqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 21:46:09 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38873 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752134AbXFYBqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 21:46:08 -0400
Date: Mon, 25 Jun 2007 03:46:28 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Benjamin LaHaise <bcrl@kvack.org>,
       Oleg Verych <olecom@flower.upol.cz>, rae l <crquan@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: -Os versus -O2
Message-ID: <20070625014627.GC1094@stusta.de>
References: <E1I20Wr-00064i-T0@flower> <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com> <20070624222518.GA10398@flower.upol.cz> <1182723318.6819.5.camel@laptopd505.fenrus.org> <20070624232314.GA971@kvack.org> <1182730156.6819.8.camel@laptopd505.fenrus.org> <20070625001203.GB971@kvack.org> <1182731022.6819.10.camel@laptopd505.fenrus.org> <20070625004106.GA1094@stusta.de> <467F1B8D.3080507@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <467F1B8D.3080507@garzik.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 09:34:05PM -0400, Jeff Garzik wrote:
> Adrian Bunk wrote:
>> The interesting questions are:
>> Does -Os still sometimes generate faster code with gcc 4.2?
>> If yes, why?
>
> Smaller code can mean fewer page faults, fewer cache invalidations, etc.
>
> It's not just a matter of compiler code generation, gotta look at the whole 
> picture.

Sure, but my point is that if the kernel is considered special and the 
best optimization for the kernel is therefore between -Os and -O2, we 
should try to find this point of best optimization.

This should address Arjans point that -Os might not be best choice for 
best performance (and it's actually our fault if gcc generates stupid 
but small code when we use -Os).

> 	Jeff

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

