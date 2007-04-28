Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbXD1Joa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbXD1Joa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 05:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbXD1Jo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 05:44:29 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46007 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753395AbXD1Jo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 05:44:28 -0400
Date: Sat, 28 Apr 2007 10:48:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mike Mattie <codermattie@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: htpt366 PCI latency value is really high
Message-ID: <20070428104811.574de77b@the-village.bc.nu>
In-Reply-To: <20070427230950.33d4d040@reforged>
References: <20070426064927.13d0ed72@reforged>
	<4630B789.3040402@ru.mvista.com>
	<20070427230950.33d4d040@reforged>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

O> I have ran with a setting of 40 for a couple of days without any trouble.
> There are many reasons a card would default to a higher level, but in
> the end it is basically tuning the card for a server application.
> 
> A warning that some cards default to high PCI latency values; settings that 
> can interfere with latency sensitive devices such as sounds cards - this 
> could be a help to others.  

A warning that there are quite a few cards that subtly corrupt your data
if you don't have the latency set to values to work around chip errata is
also worth making.

You fiddle with PCI latency values at your peril, and preferably with the
data sheet and errata docs to hand.

Alan
