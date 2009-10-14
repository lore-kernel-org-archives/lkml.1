Return-Path: <linux-kernel-owner+w=401wt.eu-S934518AbZJNPZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934518AbZJNPZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934498AbZJNPZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:25:11 -0400
Received: from trinity.develer.com ([83.149.158.210]:50355 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934421AbZJNPZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:25:09 -0400
Subject: [SOLVED] Re: sata_mv 0000:03:06.0: PCI ERROR; PCI IRQ
 cause=0x30000040
From: Bernie Innocenti <bernie@codewiz.org>
To: Tony Vroon <tony@linx.net>
Cc: Mark Lord <liml@rtr.ca>, Harri Olin <harri.olin@gmail.com>,
       linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       sysadmin <sysadmin@gnu.org>
In-Reply-To: <1255021787.3386.24.camel@localhost>
References: <1254546642.1438.135.camel@giskard> <4ACA6904.1060509@rtr.ca>
	 <4ACB3741.2030101@gmail.com> <1254852272.1471.172.camel@giskard>
	 <4ACBA33C.7090606@rtr.ca>  <1254873978.1471.463.camel@giskard>
	 <1254879618.1471.525.camel@giskard>  <4ACC076F.7020000@rtr.ca>
	 <1255020134.30440.698.camel@giskard>  <1255021787.3386.24.camel@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Sugar Labs - http://www.sugarlabs.org/
Date: Wed, 14 Oct 2009 11:24:25 -0400
Message-Id: <1255533865.19998.214.camel@giskard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 08-10-2009 a las 18:09 +0100, Tony Vroon escribió:
> On Thu, 2009-10-08 at 12:42 -0400, Bernie Innocenti wrote:
> > El Tue, 06-10-2009 a las 23:13 -0400, Mark Lord escribió:
> > I want to try reducing the frequency of the PCI-X bus, but the BIOS does
> > not seem to provide a setting for it.  Is there another way?
> 
> Generally this is done with a physical jumper on the board instead.
> You'll find it near to the bridge chip, which is almost always by NEC.
> Another technique to slow the bridge down is to insert a regular PCI
> card in the other slot (these bridges tend to offer 2 or 3 slots). As
> the weakest link, it'll drag everything down to 33MHz.
> An old PCI-X 66MHz-only card may prove helpful here as well. You don't
> have to drive it in any way; getting power to it is sufficient.

Hurray! It seems we've fixed our stability issue at last.

We forced the bus speed down to PCI-X 66MHz for both buses by shorting
pins 1-2 of the on-board jumpers.

-- 
   // Bernie Innocenti - http://codewiz.org/
 \X/  Sugar Labs       - http://sugarlabs.org/

