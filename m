Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbZIUKLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbZIUKLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 06:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbZIUKLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 06:11:04 -0400
Received: from mga12.intel.com ([143.182.124.36]:46675 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755907AbZIUKLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 06:11:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,424,1249282800"; 
   d="scan'208";a="189812889"
Date: Mon, 21 Sep 2009 11:06:38 +0100
From: Alan Cox <alan@linux.intel.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Amit Shah <amit.shah@redhat.com>, rusty@rustcorp.com.au,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
 generic guest and host communication
Message-ID: <20090921110638.02a2e3e1@linux.intel.com>
In-Reply-To: <4AB3C988.2040303@codemonkey.ws>
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com>
	<1252678386-17404-2-git-send-email-amit.shah@redhat.com>
	<20090911170010.34c80f2d@linux.intel.com>
	<20090911163806.GB25535@amit-x200.redhat.com>
	<4AAA8838.1080106@codemonkey.ws>
	<20090911173307.GB27046@amit-x200.redhat.com>
	<4AAA8A56.3040707@codemonkey.ws>
	<20090916112332.6bf981a5@linux.intel.com>
	<4AB164A0.8000402@codemonkey.ws>
	<20090918170048.53ba8cf6@linux.intel.com>
	<4AB3C988.2040303@codemonkey.ws>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Again, this is paravirtual serial device and I think it's entirely 
> reasonable for people to hook up these ports in the guest directly to 
> physical serial devices in the host.

virtio doesn't support all those features.

> I fail to see how this is at all relevant.  This is a virtual
> machine, we're presenting virtual hardware that behaves like a serial
> device.

The more important question is what you are using it for, and when you
ask that question it looks remarkably unlike a tty or serial port and
rather more like a message and status passing bus ?
