Return-Path: <linux-kernel-owner+w=401wt.eu-S933203AbXB1RNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203AbXB1RNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:13:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbXB1RNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:13:04 -0500
Received: from wilma.widomaker.com ([204.17.220.5]:3615 "EHLO
	wilma.widomaker.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933203AbXB1RNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:13:02 -0500
X-Greylist: delayed 4166 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Feb 2007 12:13:02 EST
Date: Wed, 28 Feb 2007 11:14:12 -0500
From: Charles Shannon Hendrix <shannon@widomaker.com>
To: Gerhard Mack <gmack@innerfire.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 SATA error
Message-ID: <20070228111412.4d8a2d72@daydream.goid.lan>
In-Reply-To: <Pine.LNX.4.64.0702280739510.21113@mtl.rackplans.net>
References: <Pine.LNX.4.64.0702280739510.21113@mtl.rackplans.net>
Organization: Big Endian
X-Mailer: Sylpheed-Claws 2.5.4 (GTK+ 2.8.20; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Feb 2007 07:40:23 -0500 (EST)
Gerhard Mack <gmack@innerfire.net> wrote:

> hello, 
> 
> Can someone tell me what this means?
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x400000 action 0x2 frozen
> ata1.00: cmd 35/00:00:40:a6:23/00:04:00:00:00/e0 tag 0 cdb 0x0 data 524288 
> out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: port is slow to respond, please be patient (Status 0xd0)
> ata1: port failed to respond (30 secs, Status 0xd0)
> ata1: soft resetting port
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: configured for UDMA/100

I am fairly certain this is a bug in the 2.6.20 kernel.

I never see it in 2.6.19*, just 2.6.20.

It is some kind of but in the SATA code paths, or at least that's all it
appears to affect on my system.

What chipset do you have?

I have an nforce4 chipset.

In another thread, I think they were saying it was either a SATA chipset
driver bug, or a problem in libata core.


-- 
shannon                      | governorrhea: 
                             | a contagious disease that spreads from
                             | the governor of a state downward through other 
                             | offices and his corporate sponsors
