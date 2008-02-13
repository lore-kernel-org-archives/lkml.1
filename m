Return-Path: <linux-kernel-owner+w=401wt.eu-S1763268AbYBMCKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763268AbYBMCKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbYBMCKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:10:17 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:41198 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600AbYBMCKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:10:15 -0500
Message-ID: <47B2517E.3080606@garzik.org>
Date: Tue, 12 Feb 2008 21:10:06 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: chris.mason@oracle.com, jengelh@computergmbh.de,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
References: <200802120849.34477.chris.mason@oracle.com>	<Pine.LNX.4.64.0802121458420.21102@fbirervta.pbzchgretzou.qr>	<200802120908.59602.chris.mason@oracle.com> <20080212.153329.98384016.davem@davemloft.net>
In-Reply-To: <20080212.153329.98384016.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Chris Mason <chris.mason@oracle.com>
> Date: Tue, 12 Feb 2008 09:08:59 -0500
> 
>> I've had requests to move the super down to 64k to make room for
>> bootloaders, which may not matter for sparc, but I don't really plan
>> on different locations for different arches.
> 
> The Sun disk label sits in the first 512 bytes and the boot loader
> block sits in the second 512 bytes.
> 
> I think leaving even more space is a good idea for several reasons.


Yep.  I chose 32K unused space in the prototype filesystem I wrote [1, 
2.4 era].  I'm pretty sure I got that number from some other filesystem, 
maybe even some NTFS incarnation.  It's just good practice to avoid the 
first and last "chunks" of a partition, FSVO chunk.

	Jeff


[1] http://kernel.org/pub/linux/kernel/people/jgarzik/ibu/
