Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbZJTG7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbZJTG7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 02:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZJTG7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 02:59:15 -0400
Received: from mx51.mymxserver.com ([85.199.173.110]:29411 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbZJTG7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 02:59:15 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: Implement support for rt2800pci
Date: Tue, 20 Oct 2009 08:58:54 +0200
User-Agent: KMail/1.9.7
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       users@host1.serialmonkey.com, Alban Browaeys <prahal@yahoo.com>,
       Benoit PAPILLAULT <benoit.papillault@free.fr>,
       Felix Fietkau <nbd@openwrt.org>,
       Luis Correia <luis.f.correia@gmail.com>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       Mark Asselstine <asselsm@gmail.com>,
       Xose Vazquez Perez <xose.vazquez@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <200910152137.58164.IvDoorn@gmail.com> <200910171654.03344.bzolnier@gmail.com> <200910181859.22413.IvDoorn@gmail.com>
In-Reply-To: <200910181859.22413.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910200858.54683.hs4233@mail.mn-solutions.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't agree on this, for starters the whole "abstraction
> layer as done in the staging driver, really obfuscated the code
> in multiple areas 

Ivo, you could look at Orinoco or Libertas. Both WLAN drivers 
support a multitude of different hardware (Libertas: CF/PCMCIA, 
SDIO, SD, USB and Orinoco: CF/PCMCIA, PCI, PPC_PMAC). And both 
have hardware abstraction layers that don't suck, obfuscate or 
create lots of duplicate code.

So AFAIK it's not the question *IF* to do hardware abstraction 
but only a question *HOW* to do it in an intelligent way. Don't 
luck at one bad implementation and disregard the whole 
concept :-)

-- 
http://www.holgerschurig.de
