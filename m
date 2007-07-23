Return-Path: <linux-kernel-owner+w=401wt.eu-S933464AbXGWI6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933464AbXGWI6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932980AbXGWI4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:56:44 -0400
Received: from users.crfreenet.org ([81.92.145.1]:37895 "EHLO
	mail.crfreenet.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765914AbXGWI4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:56:41 -0400
Date: Mon, 23 Jul 2007 10:56:36 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: david@lang.hm, Igor Stoppa <igor.stoppa@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Power Management framework proposal
Message-ID: <20070723085636.GA4123@localhost.localdomain>
References: <Pine.LNX.4.64.0707212339550.6350@asgard.lang.hm> <1185091022.19678.28.camel@localhost.localdomain> <Pine.LNX.4.64.0707220057210.6350@asgard.lang.hm> <1185105911.29238.43.camel@localhost.localdomain> <Pine.LNX.4.64.0707221156210.6350@asgard.lang.hm> <1185145766.2714.27.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0707221914550.6350@asgard.lang.hm> <1185162647.2714.35.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0707222054060.6350@asgard.lang.hm> <1185164357.2714.49.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185164357.2714.49.camel@laptopd505.fenrus.org>
X-Operating-System: Debian GNU/Linux 3.1 (Sarge)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 09:19:17PM -0700, Arjan van de Ven wrote:
> let me give you a real world example then, and the numbers I'm using are
> ballpark the same as you'll find in a (mobile) core 2 duo datasheet, I
> just rounded them a little so that the math works out nice.
> 
> power at full speed: 34W
> power at half speed: 24W
> power at idle: 1W

I have usually seen different numbers, for example:

http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/30430.pdf

Although this paper speaks about thermal design power instead of power
consumption, i suppose that it should be roughly equal.

For example Athlon 64 3700 (ADA3700AEP5AR):

2.4 GHz, 1.5 V -> 89 W
2.2 GHz, 1.4 V -> 72 W
2.0 GHz, 1.3 V -> 53 W
1.8 GHz, 1.2 V -> 39 W
1.0 GHz, 1.1 V -> 22 W


Even my measurement on PC (Athlon X2, VIA K8T890) of complete PC power
consumption shows that it is more efficient to be busy for 2 time units
on 1 GHz than be busy for 1 time unit and be idle for 1 time unit
on 2 GHz.

1 GHz:
both cores idle:	48 W
one core busy:		57 W
two cores busy:		66 W

2 GHz:
both cores idle:	54 W
one core busy:		78 W
two cores busy:		95 W

-- 
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org, jabber: santiago@njs.netlab.cz)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."
