Return-Path: <linux-kernel-owner+w=401wt.eu-S932226AbXBNMgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbXBNMgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 07:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932228AbXBNMgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 07:36:48 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44176 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932226AbXBNMgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 07:36:47 -0500
Date: Wed, 14 Feb 2007 12:49:01 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Zachary Amsden <zach@vmware.com>
Cc: Andi Kleen <ak@muc.de>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
Message-ID: <20070214124901.2579bd12@localhost.localdomain>
In-Reply-To: <45CAE87E.8070502@vmware.com>
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>
	<20070206122729.GC47229@muc.de>
	<45C8FA2D.6010706@vmware.com>
	<d120d5000702070658l1c018565n34a6d8814a20184d@mail.gmail.com>
	<45CA535D.1080700@vmware.com>
	<20070208082443.GA9928@muc.de>
	<45CAE87E.8070502@vmware.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> No, not that.  But the virtual keyboard I/O gets processed and converted 
> to physical keyboard I/O when a keyboard is attached to a VM.  The 
> result is that the virtual keyboard spinning out of control causes the 
> physical keyboard to receive the same commands, far too rapidly.
> 
> So the keyboard blinks out of control and acts as if possessed by demons.

Which is a good example of why breaking udelay is the wrong thing to do.
I bet vmware keyboard emulation isn't the only problematic case.

Alan
