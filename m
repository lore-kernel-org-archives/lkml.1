Return-Path: <linux-kernel-owner+w=401wt.eu-S1759067AbZCNVnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067AbZCNVnA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758740AbZCNVll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:41:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46345 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758735AbZCNVlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:41:40 -0400
Date: Sat, 14 Mar 2009 21:42:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Kasprzak <kas@fi.muni.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: MOXA I/O errors on 2.6.28+
Message-ID: <20090314214230.352d293e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090314213630.GA3375@fi.muni.cz>
References: <20090314213630.GA3375@fi.muni.cz>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Mar 2009 22:36:30 +0100
Jan Kasprzak <kas@fi.muni.cz> wrote:

> 	Hello,
> 
> I have several servers with MOXA C320 serial boards. Starting with 2.6.28,
> some ports on MOXA boards sometimes get to a state where open("/dev/ttyMX<n>")
> returns -EIO. I use the servers with MOXA boards as serial console hubs,
> and I think the EIO state is caused by the remote getty or the whole remote
> server being restarted.

Sounds like a refcount bug.

> 	2.6.27 is OK, 2.6.28 and 2.6.29-rc8 is faulty. I can git bisect
> if you want (I have a spare server which I can reboot at will).

Might be useful but let me take a look first, chances are you've provided
enough information
> 
> 	My MOXA boards are
> 
> 01:08.0 Serial controller: Moxa Technologies Co Ltd Intellio C320 Turbo PCI (rev 02)
> 
> 	What can I do to have this problem fixed? Thanks,

Step 1: Report it giving accurate detailed info... which you've done
nicely.

Alan
