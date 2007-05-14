Return-Path: <linux-kernel-owner+w=401wt.eu-S1758813AbXENRol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758813AbXENRol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbXENRof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:44:35 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:36063 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbXENRoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:44:34 -0400
Date: Mon, 14 May 2007 19:44:32 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.21] circular locking dependency found in QUOTA OFF
Message-ID: <20070514174432.GI27528@vanheusden.com>
References: <fa.UIDGHS72acFv9jKylmdQQwWcXPA@ifi.uio.no> <fa.fKNBJtZJWOQthlLjc1TDfY6jCLc@ifi.uio.no> <4646082D.2080502@shaw.ca> <m33b208z5f.fsf@maximus.localdomain> <46479E95.6050507@tmr.com> <20070513235341.GA4270@havoc.gtf.org> <46486DEC.1080506@tmr.com> <3262.62.177.207.163.1179152484.squirrel@klant.bhosted.nl> <6bffcb0e0705141043m6a5b7d22p11ec15723f3f8593@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0705141043m6a5b7d22p11ec15723f3f8593@mail.gmail.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Tue May 15 18:19:06 CEST 2007
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to me with PGP!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> [adding Jan and fsdevel to CC]
> Hi Folkert,
> >When I cleanly reboot my pc running 2.6.21 on a P4 with HT and 2GB of ram
> >and system on an 1-filesystem IDE disk, I get the following circular
> >locking dependency error:
> >
> >[330961.226405] =======================================================
> >[330961.226489] [ INFO: possible circular locking dependency detected ]
> >[330961.226531] 2.6.21 #5
...
> >[330961.236402]  [<c1003f74>] syscall_call+0x7/0xb
> >[330961.236473]  =======================
> 
> Is this a 2.6.21 regression?

This is new for 2.6.21, yes.


Folkert van Heusden

-- 
MultiTail est un flexible tool pour suivre de logfiles et execution de
commandements. Filtrer, pourvoir de couleur, merge, 'diff-view', etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
