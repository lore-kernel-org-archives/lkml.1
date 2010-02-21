Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0BUKMW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 05:12:22 -0500
Received: from senator.holtmann.net ([87.106.208.187]:58319 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab0BUKMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 05:12:20 -0500
Subject: Re: Firmware versioning best practices II
From: Marcel Holtmann <marcel@holtmann.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Vipin Mehta <Vipin.Mehta@atheros.com>
In-Reply-To: <1266665535.1820.4238.camel@macbook.infradead.org>
References: <43e72e891002191823h3245bc0cn7a8745ae77409aa8@mail.gmail.com>
	 <1266662106.1820.4034.camel@macbook.infradead.org>
	 <1266663639.10357.1.camel@jlt3.sipsolutions.net>
	 <1266664166.1820.4165.camel@macbook.infradead.org>
	 <1266664247.11514.0.camel@jlt3.sipsolutions.net>
	 <1266665535.1820.4238.camel@macbook.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Feb 2010 11:13:42 +0100
Message-ID: <1266747222.18491.5.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

> > > > That doesn't make much sense anyway. If the firmware filename is
> > > > foo-$APIVER-$CODEVER every code change would need a corresponding
> > > driver
> > > > change. If it is just foo-$APIVER then the $CODEVER can be embedded
> > > in
> > > > the firmware file and printed so you know which code you're using,
> > > but
> > > > if it doesn't influence the API I don't see why it should be part of
> > > the
> > > > filename? 
> > > 
> > > The idea is that just like with shared libraries, you have a symlink
> > > from the 'soname' foo-3.fw to the actual file foo-3-1.4.1.fw.
> > 
> > Ah ok. I indeed do that manually with iwlwifi firmware :)
> > 
> > > For shared libraries, it's easy to create those symlinks automatically
> > > using ldconfig. For firmware that doesn't really work though -- since
> > > the soname isn't encoded in the file like it is in ELF libraries.
> > 
> > Right. Though I guess we could come up with a unified firmware wrapper
> > format that the firmware loader can unwrap.
> 
> I suppose we could, but this seems like overkill to me.

I have to agree. This looks like total overkill to me.

Just use the $APIVER in the firmware filename. And if someone wants to
keep track of more details then they can manually symlink them.

Unless we have full control over the source code of every firmware used
in the kernel, why bother. It is up to the companies providing them
anyway to make sure everything works as expected and the community can't
fix it.

Regards

Marcel


