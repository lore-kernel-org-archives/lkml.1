Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbZETJMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbZETJMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754126AbZETJMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:12:25 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:39655 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbZETJMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:12:25 -0400
From: Karsten Keil <keil@b1-systems.de>
Organization: B1-systems
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 01/19] Add XHFC support for embedded Speech-Design board to hfcmulti
Date: Wed, 20 May 2009 11:12:21 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au, i4ldeveloper@listserv.isdn4linux.de
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de> <20090519.121116.52530205.davem@davemloft.net> <1242789181.3147.18.camel@localhost.localdomain>
In-Reply-To: <1242789181.3147.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905201112.22062.keil@b1-systems.de>
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,
Hi Dave,

On Mittwoch, 20. Mai 2009 05:13:01 Marcel Holtmann wrote:
> Hi Karsten,
>
> > I have been applying some gigaset patches into the net-next-2.6
> > and I would therefore suggest that you push ISDN changes bound
> > for the next kernel release via the networking tree as well.
> >
> > In fact I'm very surprised that you're not at least CC:'ing
> > netdev@vger.kernel.org with these patches.  Not only would they get
> > review for networking specific issues they would also get your patches
> > tracked automatically at:

My idea was to not send it on too much lists, but I think you are right, 
netdev@vger.kernel.org should be  used here and since it should go via the net 
tree it should be the default.

> >
> > 	http://patchwork.ozlabs.org/project/netdev/list/
> >
> > Can you at least state how you intend to manage the ISDN changes you
> > queue up?  Are you going to submit them independantly and straight to
> > Linus or are you going to play along and get them in via my
> > net-next-2.6 tree in order to avoid all of the merge hassles?
>
> since mISDN uses AF_ISDN and sockets, I personally would prefer if they
> go via net-2.6 and net-next-2.6 trees. This makes it a lot simpler in
> case of merge conflicts during the merge windows.
>

Yes, you are right, I queued it for linux-next because I was remembering that 
somebody did suggest this in the past, but this was not really a good idea.
I will setup a new merge tree based on net-2.6-next  (or better net-2.6) ?

Karsten

