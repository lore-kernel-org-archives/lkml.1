Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbZJTQbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbZJTQbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 12:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZJTQbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 12:31:12 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:41521 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbZJTQbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 12:31:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=pcDxsKySjyWEzeSdbVKIEQAB1YCwFAkKkezZJRZTci8oDhOPWcPzOrBMuSrfEFFJYp
         0WaakKOdKb5lcUmpDjIj0fX7iSPwPQ+a3AH8jhnkVCzpKQ7nUVoofX4cvDuzIjMYDQhO
         VSpKC5aX1WR/KxHoJKFxgU6LdafwsiftUVyy4=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: [PATCH 2/2] rt2x00: Implement support for rt2800pci
Date: Tue, 20 Oct 2009 18:31:11 +0200
User-Agent: KMail/1.9.10
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
References: <200910152137.58164.IvDoorn@gmail.com> <200910181859.22413.IvDoorn@gmail.com> <200910200858.54683.hs4233@mail.mn-solutions.de>
In-Reply-To: <200910200858.54683.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910201831.12285.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 October 2009, Holger Schurig wrote:
> > I don't agree on this, for starters the whole "abstraction
> > layer as done in the staging driver, really obfuscated the code
> > in multiple areas 
> 
> Ivo, you could look at Orinoco or Libertas. Both WLAN drivers 
> support a multitude of different hardware (Libertas: CF/PCMCIA, 
> SDIO, SD, USB and Orinoco: CF/PCMCIA, PCI, PPC_PMAC). And both 
> have hardware abstraction layers that don't suck, obfuscate or 
> create lots of duplicate code.

Thanks,

> So AFAIK it's not the question *IF* to do hardware abstraction 
> but only a question *HOW* to do it in an intelligent way. Don't 
> luck at one bad implementation and disregard the whole 
> concept :-)

Oh I completely agree, I am not against the extra abstraction layer,
but I do want a nice looking solution. :) I'll take a look at the Orinoco approach.

Thanks,

Ivo
