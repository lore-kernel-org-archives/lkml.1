Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbXLATk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbXLATk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 14:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbXLATkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 14:40:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37018 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbXLATkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 14:40:08 -0500
Date: Sat, 1 Dec 2007 11:38:15 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Lord <lkml@rtr.ca>, "Eric W. Biederman" <ebiederm@xmission.com>,
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
Message-ID: <20071201113815.5df0960a@freepuppy.rosehill>
In-Reply-To: <20071201192341.6750fbdb@the-village.bc.nu>
References: <m163zi9425.fsf@ebiederm.dsl.xmission.com>
	<47515D39.9030900@rtr.ca>
	<20071201111736.297dd99a@freepuppy.rosehill>
	<20071201192341.6750fbdb@the-village.bc.nu>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Dec 2007 19:23:41 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Then init_net needs to be not GPL limited. Sorry, we need to allow
> > non GPL network drivers.  There is a fine line between keeping the
> 
> Why - they aren't exactly likely to be permissible by law

Matter of debate in which there are several opinions.
I don't like binary modules either, but don't feel qualified to render
a legal opinion.

> 
> > binary seething masses from accessing random kernel functions, and allowing
> > reasonable (but still non GPL) things like ndiswrapper to use network
> > device interface.
> 
> Its up to the ndiswrapper authors how the licence their code, but they
> should respect how we licence ours.

Then change the license, explicitly and get it approved, forcing license
changes by technically subversive means is bad policy. It is like Euro bureaucrats
sneaking in software patents in regulations. If you want to have the debate and
can get it resolved, then I support you.

Actually, the whole mess would go away if the api for dev_get_by_XXXX hadn't
been changed in the namespace transition. IMHO the interface to dev_get_by_name()
should not have added a namespace parameter, of the callers in the tree, only
two use a different namespace. So it would have been better to to introduce
dev_get_by_name_ns() with the extra parameter.

Can we get this resolved before 2.6.24 is released? Going back and forth
on API's is just needless frottage.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
