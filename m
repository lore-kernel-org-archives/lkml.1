Return-Path: <linux-kernel-owner+w=401wt.eu-S1757101AbXHBOwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbXHBOwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 10:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbXHBOvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 10:51:55 -0400
Received: from users.crfreenet.org ([81.92.145.1]:32852 "EHLO
	mail.crfreenet.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751008AbXHBOvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 10:51:54 -0400
Date: Thu, 2 Aug 2007 16:51:52 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Herbert Rosmanith <kernel@wildsau.enemy.org>,
       linux-kernel@vger.kernel.org
Subject: Re: renaming kernel devices [was: VIA EPIA EK: strange eth dev numbering]
Message-ID: <20070802145152.GB19346@localhost.localdomain>
References: <200708021056.l72Au722008603@wildsau.enemy.org> <46B1BEB8.70104@msgid.tls.msk.ru> <Pine.LNX.4.64.0708021346300.24572@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708021346300.24572@fbirervta.pbzchgretzou.qr>
X-Operating-System: Debian GNU/Linux 3.1 (Sarge)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 01:47:23PM +0200, Jan Engelhardt wrote:
> It does not rename ethX to the "next free" one, but to a _persistent_ one.
> If it were a "next free" thing, then removing a card would shuffle all
> your eth around again (and invalidate your iptables rules at the same
> time, to note).

It is questionable what is _persistent_ . MAC-based names are persistent
with regard to adding and removing of other cards, 'Plain' names are persistent
with regard to replacing that card with different item (of a same kind).

I am very happy that (using 'plain' names) i can send technician to
replace broken NIC in our routers without need for configuration
change.

-- 
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org, jabber: santiago@njs.netlab.cz)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."
