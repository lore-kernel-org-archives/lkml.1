Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbYAOVd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbYAOVd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755143AbYAOVdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:33:51 -0500
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4551 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241AbYAOVdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:33:50 -0500
Date: Tue, 15 Jan 2008 22:33:30 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Lee Revell <rlrevell@joe-job.com>
Cc: Jan Marek <linux@hazard.jcu.cz>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Is it possible to change IRQ for certain device?
Message-ID: <20080115213330.GR4263@vanheusden.com>
References: <20080110110535.GA25706@hazard.jcu.cz> <Pine.LNX.4.61.0801100855300.32310@chaos.analogic.com> <20080111165711.GA21173@hazard.jcu.cz> <75b66ecd0801131957s1e70bda9x342f16a7d16a2789@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75b66ecd0801131957s1e70bda9x342f16a7d16a2789@mail.gmail.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Tue Jan 15 21:39:07 CET 2008
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why is a shared IRQ a problem for you?  IRQ handlers are supposed to
> be fast enough that disabling an IRQ line for the duration of the
> handler execution should not be a problem even if the IRQ is shared.

Take the 'zaptel' driver for example, for FXO cards for Asterisk for
example. They hate to share their irq. In fact: they refuse to work when
their irq is shared.


Folkert van Heusden

-- 
MultiTail na wan makriki wrokosani fu tan luku den logfile nanga san
den commando spiti puru. Piki puru spesrutu sani, wroko nanga difrenti
kroru, tya kon makandra, nanga wan lo moro.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
