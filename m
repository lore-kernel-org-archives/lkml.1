Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbYKPMhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbYKPMhF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 07:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbYKPMgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 07:36:55 -0500
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3324 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYKPMgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 07:36:54 -0500
Date: Sun, 16 Nov 2008 13:36:49 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.26] OOPS in elv_next_request
Message-ID: <20081116123642.GD4370@vanheusden.com>
References: <20081027090426.GN8318@vanheusden.com> <a8e1da0810272211s4b145bboef26801c3af0d652@mail.gmail.com> <20081030142550.GB11214@vanheusden.com> <a8e1da0810301822k3402e753m482d98f4530419a0@mail.gmail.com> <20081101161201.GQ11214@vanheusden.com> <a8e1da0811111830p2fe24b36q6c2d32205f3f1fe3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0811111830p2fe24b36q6c2d32205f3f1fe3@mail.gmail.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sat Nov 15 16:05:58 CET 2008
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > [ 7041.760087]  =======================
> > [ 7041.760087] Code: 04 24 89 e2 89 f0 e8 35 33 00 00 85 c0 74 0d 8b 1c 24 85 db 0f 85 a0 fe ff ff eb 18 8b 06 39 f0 75 dd 8b 46 0c 31 d2 8b 08 89 f0 <ff> 51 10 85 c0 75 ea 31 db 5a 89 d8 5b 5e 5f 5d c3 55 89 cd 57
> > [ 7041.760087] EIP: [<c01d352c>] elv_next_request+0x17f/0x190 SS:ESP 0068:c943ff34
> > [ 7041.760087] ---[ end trace d4b702ab996006dc ]---
> >> BTW, for 2.6.27, did you set vga=normal or other things?
> > None.
> > I also explicitly tried to set it but that didn't help
> 
> Could you try move the flush_scheduled_work to the beginning of
> floppy_module_exit function and report the test result?
> If it still does not works, please file a bug in bugzilla.kernel.org

Hi,

Bit of an issue: 2.6.26 did funky things with the display and 2.6.28 with
that patch applied throws an oops during boot (which i cannot capture
due also the screenres. issue and netconsole not working at that moment).
Will start a 2.6.27 compile with the patch.


Folkert van Heusden

-- 
Multi tail barnamaj mowahib li mora9abat attasjilat wa nataij awamir
al 7asoub. damj, talwin, mora9abat attarchi7 wa ila akhirih.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
