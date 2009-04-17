Return-Path: <linux-kernel-owner+w=401wt.eu-S1759632AbZDQJ2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632AbZDQJ2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 05:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbZDQJ2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 05:28:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36734 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754561AbZDQJ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 05:28:36 -0400
Date: Fri, 17 Apr 2009 10:29:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Nicholson <robert.nicholson@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Does the linux kernel contain support for ATA Security feature
 set?
Message-ID: <20090417102949.6c2b663a@lxorguk.ukuu.org.uk>
In-Reply-To: <CC1C24F4-B448-4453-BA6C-EF436231B267@gmail.com>
References: <CC1C24F4-B448-4453-BA6C-EF436231B267@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So does the Linux kernel support the ATA security set then? or does

It supports pass through of ATA commands: See man hdparm

> it, like OSX have protective measures to stop abuse of those features.

The kernel doesn't but your BIOS or in some distributions early boot
scripts may well issue a security freeze.

Alan
