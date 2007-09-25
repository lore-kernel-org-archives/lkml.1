Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbXIYHxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbXIYHxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 03:53:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbXIYHxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 03:53:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:12942 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbXIYHxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 03:53:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:references:subject:message-id:x-mailer;
        b=eP3tNpAKKd6YWm5YFSJO4c3IZxxCWyfQYLxJY5xlZOAFu8EH8fQv1v+ZKZF5qsdBHVHix81AKyk9AEyNwnZjLXUO6gWjInw1JONWMkPgZ0+bT4TRDLa6vfA+H8tXsrItyjbtJazU9pUreMIPge23BiXQz9KJ7CK/6zQVdx9xQgs=
Date: Tue, 25 Sep 2007 15:52:52 +0800
From: "Peer Chen" <peerchen@gmail.com>
To: "jeff" <jeff@garzik.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ide" <linux-ide@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>
References: <200709251323031982245@gmail.com>,
 <46F8B3F8.1050909@garzik.org>
Subject: Re: Re: [PATCH] sata_nv,ahci: add the ahci legacy mode support to sata_nv
Message-ID: <200709251552483357334@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We have three mode for one controller - IDE/RAID/AHCI, we want sata_nv being load when user select the IDE mode in BIOS, load ahci driver if RAID/AHCI being selected, which will verify if our legacy mode work well and have additional option if there is any
bug for the ahci mode.

----------------				 
Peer Chen
2007-09-25

-------------------------------------------------------------
发件人：Jeff Garzik
发送日期：2007-09-25 15:08:45
收件人：Peer Chen
抄送：linux-kernel; linux-ide; akpm
主题：Re: [PATCH] sata_nv,ahci: add the ahci legacy mode support to sata_nv

Peer Chen wrote:
> Add the ahci controller legacy mode support to sata_nv.
> Move the DIDs of legacy mode from ahci.c to sata_nv.c
> 
> The patch base on kernel 2.6.23-rc8
> 
> Signed-off-by: Peer Chen <peerchen@gmail.com>

I don't understand why these are being moved?

If an interface can be driven via the AHCI driver, that is greatly 
preferred over the sata_nv driver.

	Jeff




