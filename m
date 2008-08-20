Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbYHTSNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbYHTSNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 14:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbYHTSMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 14:12:51 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3653 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbYHTSMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 14:12:50 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: 2.6.26/tg3 ping roundtrip times > 2000 ms on local network
From: "Michael Chan" <mchan@broadcom.com>
To: "Marc Haber" <mh+linux-kernel@zugschlus.de>
cc: "Matthew Carlson" <mcarlson@broadcom.com>,
       "David Miller" <davem@davemloft.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080820174752.GB18419@torres.zugschlus.de>
References: <20080819172019.GA5823@torres.zugschlus.de>
 <20080819.132040.188336475.davem@davemloft.net>
 <1219166962.13090.12.camel@HP1>
 <20080819221439.GA19106@torres.zugschlus.de>
 <20080819223025.GA11221@xw6200.broadcom.net>
 <20080820174752.GB18419@torres.zugschlus.de>
Date: Wed, 20 Aug 2008 07:11:50 -0700
Message-ID: <1219241510.10902.12.camel@HP1>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 64B281134YK8596204-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-08-20 at 10:47 -0700, Marc Haber wrote:
> On Tue, Aug 19, 2008 at 03:30:25PM -0700, Matt Carlson wrote:
> > Can you try the attached patch?  The patch reduces the delay back to
> > what it should have been.  If this helps, then it means you are being
> > bitten by the same bug the upstream patch fixed.
> 
> It looks like the issue is fixed now. Thanks for your help.
> 
> Will this fix be in 2.6.26.3 and/or 2.6.27?

It was just submitted to -stable so it should appear 2.6.26.3 or .4.
And definitely it will be fixed in 2.6.27.

> 
> Now I need to understand why the other, nearly[1] identical box didn't
> need the patch to function properly.

It depends on whether you have ASF enabled or not and what version of
ASF you have.  ASF is management firmware running inside the NIC.  When
the tg3 driver loads, it will show ASF[1] in dmesg if ASF is enabled.

> 
> Greetings
> Marc
> 
> [1] only difference is that the working box has two e1000 interfaces
> on a PCI card in addition to the two tg3 interfaces on board (all four
> of them being in use)
> 
> --
> -----------------------------------------------------------------------------
> Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
> Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 72739834
> Nordisch by Nature |  How to make an American Quilt | Fax: *49 3221 2323190
> 


