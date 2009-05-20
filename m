Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbZETDNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbZETDNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 23:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbZETDNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 23:13:16 -0400
Received: from senator.holtmann.net ([87.106.208.187]:57369 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbZETDNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 23:13:16 -0400
Subject: Re: [PATCH 01/19] Add XHFC support for embedded Speech-Design
 board to hfcmulti
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
Cc: keil@b1-systems.de, linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       i4ldeveloper@listserv.isdn4linux.de
In-Reply-To: <20090519.121116.52530205.davem@davemloft.net>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
	 <81986b3e8ddbb4501dce5add2707d5dcec449a23.1242739648.git.kkeil@pingi.linux-pingi.de>
	 <20090519.121116.52530205.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 19 May 2009 20:13:01 -0700
Message-Id: <1242789181.3147.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karsten,

> I have been applying some gigaset patches into the net-next-2.6
> and I would therefore suggest that you push ISDN changes bound
> for the next kernel release via the networking tree as well.
> 
> In fact I'm very surprised that you're not at least CC:'ing
> netdev@vger.kernel.org with these patches.  Not only would they get
> review for networking specific issues they would also get your patches
> tracked automatically at:
> 
> 	http://patchwork.ozlabs.org/project/netdev/list/
> 
> Can you at least state how you intend to manage the ISDN changes you
> queue up?  Are you going to submit them independantly and straight to
> Linus or are you going to play along and get them in via my
> net-next-2.6 tree in order to avoid all of the merge hassles?

since mISDN uses AF_ISDN and sockets, I personally would prefer if they
go via net-2.6 and net-next-2.6 trees. This makes it a lot simpler in
case of merge conflicts during the merge windows.

Regards

Marcel


