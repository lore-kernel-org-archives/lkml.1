Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab0AOUAy (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 15:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757886Ab0AOUAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 15:00:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53111 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab0AOUAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 15:00:53 -0500
Date: Fri, 15 Jan 2010 21:00:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: Arjan van de Ven <arjan@infradead.org>, Alex Chiang <achiang@hp.com>,
        Len Brown <lenb@kernel.org>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Subject: -O0 kernel Re: High cpu temperature with 2.6.32, bisection shows
	commit 69d258 (fwd)
Message-ID: <20100115195811.GB1345@ucw.cz>
References: <alpine.LNX.2.00.1001071941470.1363@localhost.localdomain> <20100108171513.GB22713@ldl.fc.hp.com> <20100109134352.3dedd4ea@infradead.org> <alpine.LNX.2.00.1001100155370.1325@localhost.localdomain> <20100109160836.26a344a9@infradead.org> <alpine.LNX.2.00.1001100226570.1325@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1001100226570.1325@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> BTW, how can I remove that irritating -O2 flag? I 'm used to compiling  
> with -O0 my debug builds in userland, because compilation is *many times* 
> faster. I should be really useful for bisections.

Actually, figuring out kernel flags for fastest kernel compilation
would be nice. Nice for bisect, and nice for slow machines. Zaurus
needs 4 hours to compile kernel, kohjinsha cca 1.5 hours.

-O0 may not fly, as inlining is needed... some tests are
 neccessary. Now that we support icc, gcc -O0 should be doable, too...

...ok, so I tried -O0.

-O2 compilation took 1250seconds, -O0 took 1167seconds and failed.

is there some fast compiler around that could be used?

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
