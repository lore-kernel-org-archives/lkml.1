Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbYJTQrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbYJTQrP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYJTQrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:47:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122AbYJTQq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:46:59 -0400
Date: Mon, 20 Oct 2008 09:46:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] 8250: Oxford Semiconductor Devices
In-Reply-To: <20081017192830.9308.94462.stgit@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0810200944490.3518@nehalem.linux-foundation.org>
References: <20081017192309.9308.74370.stgit@localhost.localdomain> <20081017192830.9308.94462.stgit@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This series was apparently never even compile-tested.

  drivers/serial/8250_pci.c:2525:37: warning: "/*" within comment
  drivers/serial/8250_pci.c: In function ‘pci_oxsemi_tornado_init’:
  drivers/serial/8250_pci.c:1869: error: ‘PCI_VENDOR_OXSEMI’ undeclared (first use in this function)
  drivers/serial/8250_pci.c:1869: error: (Each undeclared identifier is reported only once
  drivers/serial/8250_pci.c:1869: error: for each function it appears in.)
  ...

Dropped as crap.

		Linus
