Return-Path: <linux-kernel-owner+w=401wt.eu-S934208AbXJRT0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208AbXJRT0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758087AbXJRT0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:26:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51190 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbXJRT0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:26:30 -0400
Subject: Re: BUG in: Driver core: convert block from raw kobjects to core
	devices
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.0710181515560.2779-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0710181515560.2779-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Thu, 18 Oct 2007 21:27:41 +0200
Message-Id: <1192735661.2271.2.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+01Q1ANwXFcBqDMAW7SzzyqxgIUm9OsMVPjrb
 0LgkW6+kbwwUYD5wQe33yR6kBtUkgvvYhalRTeislXCr0+f9R1
 dtd1gtxcg1FTEX+b0Y0Wj6p7Pzgn9an
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-18 at 15:23 -0400, Alan Stern wrote:
> This patch (as1004) fixes a refcounting bug in the development version
> of the block-device core.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
> Kay, you have got to start testing your patches better!

That leaves references around for SCSI target devices. There must be a
bug somewhere else, if the patch isn't correct.

> Finding and
> fixing refcount errors is _not_ one of my favorite ways to pass the
> time.  For example, you could see what happens when you insert and
> unplug a USB flash disk a few times.

What do you see with the original version?

Kay

