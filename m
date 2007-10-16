Return-Path: <linux-kernel-owner+w=401wt.eu-S936144AbXJPWYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936144AbXJPWYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934737AbXJPWYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:24:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37442
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S935051AbXJPWX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:23:59 -0400
Date: Tue, 16 Oct 2007 15:24:04 -0700 (PDT)
Message-Id: <20071016.152404.35664335.davem@davemloft.net>
To: arnd@arndb.de
Cc: Geert.Uytterhoeven@sonycom.com, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: ioctl32: Unknown cmd
From: David Miller <davem@davemloft.net>
In-Reply-To: <200710162150.37636.arnd@arndb.de>
References: <Pine.LNX.4.62.0710161642200.20196@pademelon.sonytel.be>
	<200710162150.37636.arnd@arndb.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 16 Oct 2007 21:50:35 +0200

> The one point where it is expected to have changed now is when you
> try to do these ioctls on something that is not a block device. Are
> you sure that the files you tried them on were created correctly?

Many many many programs do this exact sort of thing.

It is one of the bad aspects of moving the compat handling
down into the file ops for a specific device.
