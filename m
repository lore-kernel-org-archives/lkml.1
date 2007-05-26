Return-Path: <linux-kernel-owner+w=401wt.eu-S1763313AbXEZQWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763313AbXEZQWj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 12:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758290AbXEZQWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 12:22:33 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:47837 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbXEZQWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 12:22:32 -0400
Date: Sat, 26 May 2007 18:22:31 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: mpm@selenic.com
Cc: linux-kernel@vger.kernel.org
Subject: Fw: Re: [2.6.21.1] soft lockup when removing netconsole module
Message-ID: <20070526162231.GC11760@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sun May 27 17:52:04 CEST 2007
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a key-signing at www.biglumber.com
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > Seems to be hrtimers related - CC'ed Thomas.
> 
> I doubt that. The tick interrupt just finds out, that the machine is
> stuck in rmmod.

Can you please make netconsole unloadable via rmmod? My system seems to
hang every time I do rmmod on netconsole (rmmod using 100% cpu and not
returning). Because now when the destination system gets a new
network-card or anything else changes I need to reboot the complete
(sending) machine.


Folkert van Heusden

-- 
MultiTail est un flexible tool pour suivre de logfiles et execution de
commandements. Filtrer, pourvoir de couleur, merge, 'diff-view', etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
