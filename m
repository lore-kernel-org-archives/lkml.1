Return-Path: <linux-kernel-owner+w=401wt.eu-S935959AbXJQAZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935959AbXJQAZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 20:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760959AbXJQAZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 20:25:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:60639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbXJQAZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 20:25:22 -0400
To: David Miller <davem@davemloft.net>
Cc: arnd@arndb.de, Geert.Uytterhoeven@sonycom.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: ioctl32: Unknown cmd
References: <Pine.LNX.4.62.0710161642200.20196@pademelon.sonytel.be>
	<200710162150.37636.arnd@arndb.de>
	<20071016.152404.35664335.davem@davemloft.net>
From: Andi Kleen <andi@firstfloor.org>
Date: 17 Oct 2007 02:25:20 +0200
In-Reply-To: <20071016.152404.35664335.davem@davemloft.net>
Message-ID: <p73wstmy4cv.fsf@crumb.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Arnd Bergmann <arnd@arndb.de>
> Date: Tue, 16 Oct 2007 21:50:35 +0200
> 
> > The one point where it is expected to have changed now is when you
> > try to do these ioctls on something that is not a block device. Are
> > you sure that the files you tried them on were created correctly?
> 
> Many many many programs do this exact sort of thing.
> 
> It is one of the bad aspects of moving the compat handling
> down into the file ops for a specific device.

When this happens one should add respective IGNORE_IOCTL()s to 
compat_ioctl.c

-Andi
