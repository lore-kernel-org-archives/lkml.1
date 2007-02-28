Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbXB1Owg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbXB1Owg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932913AbXB1Owg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:52:36 -0500
Received: from neopsis.com ([213.239.204.14]:33632 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932458AbXB1Owf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:52:35 -0500
Message-ID: <45E59C07.7020902@dbservice.com>
Date: Wed, 28 Feb 2007 16:13:11 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0b2 (X11/20070208)
MIME-Version: 1.0
To: Gerhard Mack <gmack@innerfire.net>
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 SATA error
References: <fa./FMiSBkno9w078cQXK8Y1+afU50@ifi.uio.no> <45E58FC7.7020102@shaw.ca> <Pine.LNX.4.64.0702280936140.28570@mtl.rackplans.net>
In-Reply-To: <Pine.LNX.4.64.0702280936140.28570@mtl.rackplans.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.381,
	required 5, autolearn=spam, AWL 0.22, BAYES_00 -2.60)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerhard Mack wrote:
> ata1.00: configured for UDMA/100
> [...]
> ata1.00: configured for UDMA/66
> [...]
> ata1.00: configured for UDMA/44
> [...]
> ata1.00: configured for UDMA/33
> [...]
> ata1.00: configured for UDMA/25
> [...]
> ata1.00: configured for UDMA/16
> [...]
> ata1.00: configured for PIO4

I have the same problem, though it appears randomly. It seems like the 
chances for this happening are bigger if I do heavy disk I/O. The only 
way to fix that is to shut down the computer and wait a few seconds 
before rebooting (if I don't wait, the problem doesn't go away). I 
bought new harddrives, so it's most likely not caused by the drives, I 
also tried putting the drives onto a different controller (I have four 
on-board SATA controller and two harddrives), that didn't help either, 
so I suspect its the cable - SATA cables are very error-prone, I don't 
trust them as they don't hold that tightly in the socket.

tom
