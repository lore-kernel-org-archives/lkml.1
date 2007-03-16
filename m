Return-Path: <linux-kernel-owner+w=401wt.eu-S966001AbXCPWjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966001AbXCPWjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 18:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966002AbXCPWjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 18:39:10 -0400
Received: from sd-green-bigip-83.dreamhost.com ([208.97.132.83]:32840 "EHLO
	swarthymail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S966001AbXCPWjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 18:39:08 -0400
Date: Fri, 16 Mar 2007 19:39:02 -0300
From: John Coppens <john@jcoppens.com>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: linux-kernel@vger.kernel.org
Subject: Re: Conflict between ide and usb?
Message-Id: <20070316193902.d2514865.john@jcoppens.com>
In-Reply-To: <20070316203415.GK22466@csclub.uwaterloo.ca>
References: <20070316154735.6de11eca.john@jcoppens.com>
	<75b66ecd0703161252l60dcbd81s3c9beb7cb91b6c14@mail.gmail.com>
	<20070316171253.2014deaf.john@jcoppens.com>
	<20070316203415.GK22466@csclub.uwaterloo.ca>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 16:34:15 -0400
lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> Do you even have DMA enabled for the DVD drive?  Without it it will be
> very slow and painful for the CPU.  I also have noticed that many fast
> (16x) DVD writers must have an 80 wire cable or they won't work
> correctly and do nasty things to the system.
> 
> Check /proc/ide/hdX/settings|grep dma and see if it says 1 0 1 or 0 0 1.

I _knew_ I enabled the DMA, but it seems that is switches off when I start
the transfer:

hdc: DMA disabled
hdc: ide_intr: huh? expected NULL handler on exit
hdc: ATAPI reset complete
ISO 9660 Extensions: RRIP_1991A
VFS: busy inodes on changed media.

This is on hdc, which is the DVD. Harddisk has DMA on.

John
