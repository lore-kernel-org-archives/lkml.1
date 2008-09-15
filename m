Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbYIOSwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbYIOSwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYIOSvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:51:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45074
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753484AbYIOSvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:51:49 -0400
Date: Mon, 15 Sep 2008 11:51:43 -0700 (PDT)
Message-Id: <20080915.115143.62965548.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: mark@mtfhpc.demon.co.uk, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       joy@entuzijast.net
Subject: Re: Allow 8250 to work on sparc.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080915172211.6751bb17@the-village.bc.nu>
References: <20080912.211854.102505246.davem@davemloft.net>
	<Pine.LNX.4.61.0809151507250.23201@mtfhpc.demon.co.uk>
	<20080915172211.6751bb17@the-village.bc.nu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Mon, 15 Sep 2008 17:22:11 +0100

> > At the user level, there is no difference between a sun zilog serial port, 
> > an 8250 serial port or a USB serial port so these should be allocated 
> > using the same allocation system.
> 
> That isn't strictly true.
> 
> > For me, it would also simplify the issue of trying to work what devive to 
> > look for when I plug in a new USB serial port device. It would be the new 
> > /dev/ttyS<x> to appear in /dev.
> 
> Naming is a private matter for udev anyway, independant of numbering for
> major/minor

True.  But I think there is some merit in having such a generic
allocator for the current users of the ttySX minor space.
