Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbZEALEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbZEALEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 07:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639AbZEALEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 07:04:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40777 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755199AbZEALEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 07:04:21 -0400
Date: Fri, 1 May 2009 12:03:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
 tmpfs
Message-ID: <20090501120359.05bacb48@lxorguk.ukuu.org.uk>
In-Reply-To: <20090501065527.GA19773@kroah.com>
References: <1241097822.2516.3.camel@poy>
	<20090430222900.c13b63d5.akpm@linux-foundation.org>
	<20090501061701.GB19234@kroah.com>
	<20090430234312.a63fa5cf.akpm@linux-foundation.org>
	<20090501065527.GA19773@kroah.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Boot speed, boot speed, boot speed.
> 
> Oh, and reduction in complexity in init scripts, and saving embedded
> systems a lot of effort to implement a dynamic /dev properly (have you
> _seen_ what Android does to keep from having to ship udev?  It's
> horrible...)

This is nothing to do with udev or the kernel side of things. Your
argument seems to be

"Remove a user space problem and make it a kernel one stuffed in
 unpageable RAM and less flexible"

It seems to me your actual problem is "my tools suck" and the fix for
that is to fix the tools not add more random kernel junk.

