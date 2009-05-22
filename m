Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbZEVNmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbZEVNmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 09:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZEVNmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 09:42:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36955 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752320AbZEVNmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 09:42:46 -0400
Date: Fri, 22 May 2009 14:43:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pantelis Koukousoulas <pktoss@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: How to tell whether a struct file is held by a process?
Message-ID: <20090522144343.7b26b3a8@lxorguk.ukuu.org.uk>
In-Reply-To: <1295ed070905220630q67c62569o9753425abf529742@mail.gmail.com>
References: <ac3eb2510905211407l3aec14acx2572a2ad4e675b9@mail.gmail.com>
	<Pine.LNX.4.44L0.0905211724050.3914-100000@iolanthe.rowland.org>
	<1295ed070905220630q67c62569o9753425abf529742@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Suppose a device needs a reset as part of its init sequence (a whole lot
> of them do, this is not purely hypothetical). Then a different process may
> get to operate the device before and after the reset and hilarity may result
> from that.

Thats surely up to you to get your lock file usage right. The kernel
isn't there to play mother to crap programming.

> So, if there is a clean / acceptable way to handle the reset issue in userspace

Firstly can you explain *why* you think there is a problem ?
