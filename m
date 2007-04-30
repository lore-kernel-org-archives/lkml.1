Return-Path: <linux-kernel-owner+w=401wt.eu-S1946787AbXD3U2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946787AbXD3U2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946784AbXD3U2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:28:00 -0400
Received: from [81.2.110.250] ([81.2.110.250]:34236 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946782AbXD3U16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:27:58 -0400
Date: Mon, 30 Apr 2007 21:31:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen.Clark@seclark.us
Cc: Jeff Garzik <jeff@garzik.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates
Message-ID: <20070430213127.49e4bd73@the-village.bc.nu>
In-Reply-To: <46364FFA.9050500@seclark.us>
References: <20070429161542.GA12501@havoc.gtf.org>
	<46364901.4000907@redhat.com>
	<46364C04.4050208@garzik.org>
	<46364FFA.9050500@seclark.us>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah the kernel will boot but the hd performance is sh*t on my laptop. I 
> am running FC6 with
> kernel 2.6.21 and without the combined_mode setting my disk performance 
> goes down to a
> whopping 1.25mb/sec from 44mb/sec when I boot with combined_mode=libata. 

Then something is very wrong with the way you are setting it up, or the
current code. Please post a dmesg booting with libata driving all your
disks and it can get fixed before 2.6.22

Do you happen to know how FC7test4 behaves on your box btw

Alan
