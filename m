Return-Path: <linux-kernel-owner+w=401wt.eu-S1751347AbXBNXZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbXBNXZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 18:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751353AbXBNXZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 18:25:48 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57746 "EHLO
	localhost.localdomain" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751347AbXBNXZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 18:25:48 -0500
Date: Thu, 15 Feb 2007 00:28:24 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akp=m@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 9/11] Panic delay fix
Message-ID: <20070215002824.03bc5f09@localhost.localdomain>
In-Reply-To: <1171493506.19842.179.camel@localhost.localdomain>
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>
	<1171493506.19842.179.camel@localhost.localdomain>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> users I'd rather try to convince the IDE maintainer to use a
> "real_hardware_mdelay()" or something here.

The IDE/ATA layer has a single function which decides what non PCI
probing to do so could learn to spot virtualisation easily enough. In the
case of libata ISA is now obscure enough that you must load a driver to
trigger ISA probes so the problem is on its way out anyway.

