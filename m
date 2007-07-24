Return-Path: <linux-kernel-owner+w=401wt.eu-S1763400AbXGXTMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763400AbXGXTMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762928AbXGXTMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:12:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34458 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762887AbXGXTMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:12:34 -0400
Date: Tue, 24 Jul 2007 21:12:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Tilman Schmidt <tilman@imap.cc>, Olaf Hering <olh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.22-git17 boot failure
Message-ID: <20070724191231.GA359@one.firstfloor.org>
References: <46A481FD.2030607@imap.cc> <46A4C081.6070305@goop.org> <46A504A3.3070205@imap.cc> <46A51079.5030006@goop.org> <46A53396.2060902@imap.cc> <46A5444D.4080304@goop.org> <20070724091018.GA26724@one.firstfloor.org> <20070724095614.GB625@suse.de> <46A64019.4010508@imap.cc> <46A64CD5.2030800@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A64CD5.2030800@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 12:02:45PM -0700, Jeremy Fitzhardinge wrote:
> Tilman Schmidt wrote:
> > Alright, I know what's going on now, and it looks like a problem with
> > the Opensuse init script. In fact, the initrd for the Xen enabled
> > kernel got a *different* init script than the one for the non-Xen one.
> > The difference being:
> >   
> 
> Phew, I was getting worried there for a minute.  Does the install script
> check for CONFIG_XEN in the kernel config or something?

Yes 10.2 mkinitrd does. But it still should work because a dom0
kernel would obviously need all the drivers. A paravirt ops
kernel native is like a dom0 variant.

http://firstfloor.org/~andi/mkinitrd

-Andi
