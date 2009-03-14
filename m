Return-Path: <linux-kernel-owner+w=401wt.eu-S1752889AbZCNIqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbZCNIqT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 04:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZCNIqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 04:46:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50002 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751116AbZCNIqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 04:46:00 -0400
Date: Sat, 14 Mar 2009 08:46:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Norman Diamond" <n0diamond@yahoo.co.jp>
Cc: "Robert Hancock" <hancockrwd@gmail.com>, <linux-kernel@vger.kernel.org>,
       <linux-ide@vger.kernel.org>, "Jim Paris" <jim@jtan.com>,
       "Sergei Shtylyov" <sshtylyov@ru.mvista.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Mark Lord" <liml@rtr.ca>
Subject: Re: Off-by-one in both LIBATA and IDE drivers
Message-ID: <20090314084628.19361f62@lxorguk.ukuu.org.uk>
In-Reply-To: <A88EBC06918A4B0789B55D31ECDAF1BB@DIAMOND8600>
References: <20090313074120.48682.qmail@web4108.mail.ogk.yahoo.co.jp>
	<49BA7172.80908@gmail.com>
	<A88EBC06918A4B0789B55D31ECDAF1BB@DIAMOND8600>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the PIIX4 devices of VMware server are well known.  Besides vendor
> 8086 and device 7111, VMware's subsystem is coded into LIBATA's PIIX driver.

That is a known working case so its something about your setup or build.

You might want to try building with CONFIG_IDE=n and CONFIG_ATA +
ATA_PIIX + AHCI = y to double check your config.
