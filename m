Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbXDRM26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbXDRM26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 08:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbXDRM26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 08:28:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44025 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752393AbXDRM25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 08:28:57 -0400
Date: Wed, 18 Apr 2007 13:29:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <htejun@gmail.com>
Cc: 7eggert@gmx.de, Chuck Ebbert <cebbert@redhat.com>,
       emisca <emisca.ml@gmail.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: Loud "pop" coming from hard drive on reboot
Message-ID: <20070418132904.3322ba5f@the-village.bc.nu>
In-Reply-To: <46260981.1040109@gmail.com>
References: <88SeR-5Sf-15@gated-at.bofh.it>
	<88Sov-662-3@gated-at.bofh.it>
	<88SHV-6uL-29@gated-at.bofh.it>
	<8agVk-3wc-81@gated-at.bofh.it>
	<8b3IR-4mE-25@gated-at.bofh.it>
	<8b3SA-4z3-5@gated-at.bofh.it>
	<8b42g-51N-15@gated-at.bofh.it>
	<8bbdm-7iS-27@gated-at.bofh.it>
	<E1He8dA-0000mw-LI@be1.lrz>
	<46260981.1040109@gmail.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Not that simple.  Most disks don't spin up on SYNCHRONIZE_CACHE if its 
> cache is clean.  Sadly some disks actually spin up when it receives spin 
> down command while spun down to immediately spin down again, so we would 
> be fixing problem for some number of disks while breaking others.  :-(

Snoop the last command sent to the drive, that tells you if you can skip
the cache flush ?
