Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbZL3X5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbZL3X5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 18:57:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbZL3X5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 18:57:07 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41909 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751543AbZL3X5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 18:57:05 -0500
X-Sasl-enc: SzwsKT32qmCUPzH0ut+bgS2Y/ltar/mSrx6cdIz/dbVj 1262217422
Date: Wed, 30 Dec 2009 21:56:59 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Joe Perches <joe@perches.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] drivers/atm/lanai.c: use %pM to show MAC address
Message-ID: <20091230235659.GH18722@khazad-dum.debian.net>
References: <BD79186B4FD85F4B8E60E381CAEE19090200F645@mi8nycmail19.Mi8.com>
 <1262199586.2545.43.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262199586.2545.43.camel@Joe-Laptop.home>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Dec 2009, Joe Perches wrote:
> > +		return sprintf(page, "EEPROM ESI: %pM\n",
> > +		    &lanai->eeprom[EEPROM_MAC]);
> 
> This is a user-visible change from upper case to lower case.
> Probably doesn't matter, but maybe...

Something would need to be _really_ broken to:

1. Parse the kernel log after MACs in the first place
2. Be case-sensitive about it

If it breaks anything, it is a breakage well deserved...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
