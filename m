Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYGDU1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYGDU1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 16:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYGDU1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 16:27:41 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:39705 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbYGDU1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 16:27:40 -0400
Date: Fri, 4 Jul 2008 22:28:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
Message-ID: <20080704202826.GA19110@uranus.ravnborg.org>
References: <1215111362.10393.651.camel@pmac.infradead.org> <20080703.162120.206258339.davem@davemloft.net> <486D6DDB.4010205@infradead.org> <87ej6armez.fsf@basil.nowhere.org> <1215177044.10393.743.camel@pmac.infradead.org> <486E2260.5050503@garzik.org> <1215178035.10393.763.camel@pmac.infradead.org> <486E2818.1060003@garzik.org> <20080704143058.GB23215@mit.edu> <1215194516.3189.5.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215194516.3189.5.camel@shinybook.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2008 at 07:01:56PM +0100, David Woodhouse wrote:
> On Fri, 2008-07-04 at 10:30 -0400, Theodore Tso wrote:
> > So on this point I'd side with David, and say that folding "make
> > firmware_install" into "make modules_install" goes a long way towards
> > healing this particular breakage.
> 
> make modules_install | tail ...
>   INSTALL fs/nfs/nfs.ko
>   INSTALL fs/nls/nls_iso8859-1.ko
>   INSTALL fs/vfat/vfat.ko
>   MKDIR   /lib/firmware/acenic
>   INSTALL /lib/firmware/acenic/tg2.bin
>   MKDIR   /lib/firmware/tigon
>   INSTALL /lib/firmware/tigon/tg3.bin
>   INSTALL /lib/firmware/tigon/tg3_tso.bin
>   INSTALL /lib/firmware/tigon/tg3_tso5.bin
>   DEPMOD  2.6.26-rc8

I have not followed the threads about firmware - but installing
the firmware on par with modules_install seems like a good idea to me.
I gave the kbuild bits a quick look and they have my:
Acked-by: Sam Ravnborg <sam@ravnborg.org>

I have yet to give all the firmware stuff a detailed review
but that will be when I get time to it.

	Sam
