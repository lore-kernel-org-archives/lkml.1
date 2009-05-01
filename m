Return-Path: <linux-kernel-owner+w=401wt.eu-S1759736AbZEANMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736AbZEANMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZEANLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:11:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43599 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751746AbZEANLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:11:52 -0400
Date: Fri, 1 May 2009 14:12:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
 tmpfs
Message-ID: <20090501141235.733d4b1b@lxorguk.ukuu.org.uk>
In-Reply-To: <9b2b86520905010538p2d781eedhd7bed86ab908c990@mail.gmail.com>
References: <1241097822.2516.3.camel@poy>
	<9b2b86520905010319g4b1e915ejc5c17baa519f3d35@mail.gmail.com>
	<ac3eb2510905010413y6b35e817nf948cedbe076cd4d@mail.gmail.com>
	<9b2b86520905010538p2d781eedhd7bed86ab908c990@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> a) running before /dev/null and /dev/console requires hacks

Not really, well not if you are writing a serious small tool anyway. In
actual fact the bigger problem if you are using the standard dynamic
link setup (which you wouldn't be I suspect) is /dev/zero.

> b) it requires an initramfs
> c) it pulls everything that hooks into or otherwise affects udev into
> the initramfs; that's much more than we have at present, and a bigger
> initramfs' can only make bootup _slower_.

Ditto a bigger kernel. Remember moving stuff from initramfs to the kernel
makes it less memory efficient usually as its now harder to get rid of
and not pageable later on either.

Alan
