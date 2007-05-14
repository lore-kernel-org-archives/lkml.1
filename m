Return-Path: <linux-kernel-owner+w=401wt.eu-S1759654AbXENWYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759654AbXENWYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbXENWYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:24:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48344 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754991AbXENWYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:24:39 -0400
Date: Mon, 14 May 2007 23:29:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hubertus Grobbel <hubertus@grobbel.net>
Cc: Linux List <linux-kernel@vger.kernel.org>
Subject: Re: O_DIRECT for FAT
Message-ID: <20070514232907.09c745f8@the-village.bc.nu>
In-Reply-To: <200705150103.02398.hubertus@grobbel.net>
References: <200705150103.02398.hubertus@grobbel.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I would like to access on certain files on a flash-disk without cache
> usage, whereas the rest of the filesystem shall be accessed normally/cached.
> I am aware of the previous discussion. My application is not targetting on a 
> pure file usage (I can live with the existing features for that), but also 
> for a side-channel IO to interact with the device. 

Assuming you basically want to be sure writes hit the media you can use
the fsync and fdatasync system calls on modern kernels to ensure your
data is on the media and is flushed when you want it not when the kernel
gets around to it out of boredom.

