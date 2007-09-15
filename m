Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbXIONBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbXIONBO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 09:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbXIONA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 09:00:58 -0400
Received: from tag.witbe.net ([81.88.96.48]:54834 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbXIONA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 09:00:57 -0400
Date: Sat, 15 Sep 2007 13:00:10 +0000
From: Paul Rolland <rol@as2917.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Adrian Bunk <bunk@kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <andi@firstfloor.org>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rol@witbe.net
Subject: Re: sata & scsi suggestion for make menuconfig
Message-ID: <20070915130010.4272403c@tux.DEF.witbe.net>
In-Reply-To: <46EB9703.70705@s5r6.in-berlin.de>
References: <20070907124800.GP16806@vanheusden.com>
	<p73fy1p9m57.fsf@bingen.suse.de>
	<1189371621.3526.28.camel@localhost.localdomain>
	<20070909210329.GE25798@one.firstfloor.org>
	<46E46190.6080607@garzik.org>
	<20070912224655.GC3563@stusta.de>
	<46EAA08F.30703@s5r6.in-berlin.de>
	<20070914151522.GL3563@stusta.de>
	<20070915080448.37457dcf@tux.DEF.witbe.net>
	<46EB9703.70705@s5r6.in-berlin.de>
Organization: AS2917.net
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stefan,

On Sat, 15 Sep 2007 10:25:39 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Paul Rolland wrote:
> > getting too much of "No help text available"
> > usually results in people no more reading the help text.
> 
> I assert that a Kconfig prompt (a visible Kconfig variable) _without_
> help text is a bug.

Here is an example from 2.6.34-rc6 :
 .config - Linux Kernel v2.6.23-rc6 Configuration
------------------------------------------------------------------------------
 +------------------------- Provide RTC interrupt -------------------------+ 
 | There is no help available for this kernel option.                      |
 | Symbol: HPET_EMULATE_RTC [=y]                                           |
 | Prompt: Provide RTC interrupt                                           |
 |   Defined at arch/x86_64/Kconfig:471                                    |
 |   Depends on: HPET_TIMER && RTC=y                                       |
 |   Location:                                                             |
 |   -> Processor type and features |   

Regards,
Paul
