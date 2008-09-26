Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYIZIrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYIZIrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 04:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYIZIq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 04:46:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57572 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751790AbYIZIqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 04:46:55 -0400
Date: Fri, 26 Sep 2008 09:46:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: marty <martyleisner@yahoo.com>
Cc: linux-kernel@vger.kernel.org, martin.leisner@xerox.com
Subject: Re: disk IO directly from PCI memory to block device sectors
Message-ID: <20080926094653.1e0a9260@lxorguk.ukuu.org.uk>
In-Reply-To: <247018.46515.qm@web50603.mail.re2.yahoo.com>
References: <247018.46515.qm@web50603.mail.re2.yahoo.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What I'm looking is for a more generic/driver independent way of sticking
> contents of PCI ram onto a disk.

Ermm seriously why not have a userspace task with the PCI RAM mmapped
and just use write() like normal sane people do ?

Alan
