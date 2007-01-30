Return-Path: <linux-kernel-owner+w=401wt.eu-S1751963AbXA3Wvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbXA3Wvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbXA3Wvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:51:44 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58102 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751963AbXA3Wvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:51:43 -0500
Date: Tue, 30 Jan 2007 23:03:58 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Matthieu CASTET <castet.matthieu@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070130230358.5ad07317@localhost.localdomain>
In-Reply-To: <loom.20070130T231421-484@post.gmane.org>
References: <20070130012904.GA9617@kroah.com>
	<ada8xfks90x.fsf@cisco.com>
	<20070130191020.GF20642@kroah.com>
	<adaodogqpmx.fsf@cisco.com>
	<45BFA087.6020905@garzik.org>
	<loom.20070130T231421-484@post.gmane.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On another side, some PATA drivers are incomplete or missing.
> 
> When we switch to PATA and drop old ide stack, what will happen ?
> Will all driver be ported and full-feature, or some will be obsoleted ?

At the moment unless anyone gets upset I expect to obsolete the CMD640
but nothing else PCI. Can't comment on non x86 drivers and that may be up
to port maintainers, and in part to polishing the core code to handle it
better.

Some vendors are trialling a libata switch in their upcoming
distributions and the only barrier I expect to need some quick fixing is
the HPA support.

Alan
