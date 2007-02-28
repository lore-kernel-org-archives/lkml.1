Return-Path: <linux-kernel-owner+w=401wt.eu-S1751133AbXB1CfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133AbXB1CfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 21:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbXB1CfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 21:35:18 -0500
Received: from mail.tmr.com ([64.65.253.246]:53346 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbXB1CfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 21:35:17 -0500
Message-ID: <45E4EAA7.2090007@tmr.com>
Date: Tue, 27 Feb 2007 21:36:23 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Florin Iucha <florin@iucha.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.20-rc1: CIFS cheers, NFS4 jeers
References: <20070226064500.GZ29073@iucha.net>
In-Reply-To: <20070226064500.GZ29073@iucha.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florin Iucha wrote:
> Hello, it's me and my 70 GB of photos again.
> 
> I have tested both CIFS and NFSv4 clients in kernel 2.6.20-rc1 . CIFS
> passed with flying colors and NFSv4 stalled after 7 GB.
> 
> Configuration:
> 
>    Server: PIII/1GHz, 512 MB RAM, Debian testing,
>       distro kernel 2.6.18-3-vserver-686, Intel E1000 NIC, 
>       filesystem 170 GB ext3 with default mkfs values on a SATA disk
>       
>    Client: AMD x2 4200+, 2 GB RAM, Debian testing/unstable
>       kernel 2.6.20-rc1, Marvell SKGE onboard,
>       filesystem 120 GB ext3 with default mkfs values on a SATA disk
> 
Neil has been diddling NFS, I did some light testing with 2.6.20-git14 
with 190GB of mp3 and mpg files (library of congress folk music) without 
hangs. Just "did it work" tests, copy 20-30GB to server, do md5 on the 
data pulled back from the server.

Didn't hang, performance testing later.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
