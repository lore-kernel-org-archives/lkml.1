Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbXLAUbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbXLAUbQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 15:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXLAUa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 15:30:56 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48803 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbXLAUay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 15:30:54 -0500
Date: Sat, 1 Dec 2007 12:29:26 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Mark Lord <lkml@rtr.ca>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Greg KH <greg@kroah.com>,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: namespace support requires network modules to say "GPL"
Message-ID: <20071201122926.5c887588@laptopd505.fenrus.org>
In-Reply-To: <4751C238.6010609@rtr.ca>
References: <m163zi9425.fsf@ebiederm.dsl.xmission.com>
	<47515D39.9030900@rtr.ca>
	<20071201111736.297dd99a@freepuppy.rosehill>
	<20071201192341.6750fbdb@the-village.bc.nu>
	<20071201113815.5df0960a@freepuppy.rosehill>
	<m13aum5g1x.fsf@ebiederm.dsl.xmission.com>
	<4751C238.6010609@rtr.ca>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Dec 2007 15:21:12 -0500
Mark Lord <lkml@rtr.ca> wrote:

> Eric W. Biederman wrote:
> > Stephen Hemminger <shemminger@linux-foundation.org> writes:
> > Sure.  We keep the updated dev_get_by_XXXX that takes a network
> > namespace parameter.
> ..
> 
> And what should code be passing in when "# CONFIG_NET_NS is not set" ?

network drivers probably really really don't want to call
dev_get_by_XXX...

in fact no NIC driver in drivers/net does so!
Sounds like whatever driver you're looking at has a nasty bug in that
it's using non-driver APIs...



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
