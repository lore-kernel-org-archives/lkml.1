Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbYHXEjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbYHXEjt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 00:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYHXEjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 00:39:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52093 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbYHXEjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 00:39:39 -0400
Message-ID: <48B0E608.4050205@garzik.org>
Date: Sun, 24 Aug 2008 00:39:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Sergey Spiridonov <sena@hurd.homeunix.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: GA-MA790FX-DS5 SATA ahci NCQ erros on Jmicron 20360/20363  (JMB363)
   kernel 2.6.25-2 Debian/Lenny
References: <g8p6po$nm$1@ger.gmane.org> <48B0916C.4080805@garzik.org> <g8q9mg$v2p$1@ger.gmane.org>
In-Reply-To: <g8q9mg$v2p$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Spiridonov wrote:
> Hi
> 
> Jeff Garzik wrote:
> 
>> So...  suspect bad cables, bad port connectors, cable interference,
>> motherboard-caused interference or grounding problems, power supply
>> problems.
> 
> I did exchange power supply and I did exchange hard drives. The same
> hard drive with the same cable works with SB600 and produces errors with
> JMB363. So looks like it is not cable or hard drive problem. May be the
> problem is JMB363 port connector on the motherboard. How can I check it?

Try new motherboard of same brand and model :/

In general, tons of ATA bus errors and SError complaints indicate some 
sort of problem at the physical layer/level.  Its always possible that 
software is to blame, but bug report patterns so far tend to point to 
hardware.

	Jeff


