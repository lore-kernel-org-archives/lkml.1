Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbXCFFne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbXCFFne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 00:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933958AbXCFFne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 00:43:34 -0500
Received: from mail.gmx.net ([213.165.64.20]:54440 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933955AbXCFFnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 00:43:33 -0500
X-Provags-ID: V01U2FsdGVkX18wrkphfgMwZmOjgbrv5ZfuCXEad4pBfmingUl9Qh
	4nti2IsrVjJpKI
Subject: Re: kref refcounting breakage in mainline
From: Mike Galbraith <efault@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <htejun@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@stusta.de>
In-Reply-To: <20070306002521.GA12164@kroah.com>
References: <20070302005833.949be737.akpm@linux-foundation.org>
	 <20070306002521.GA12164@kroah.com>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 06:43:22 +0100
Message-Id: <1173159802.6955.6.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 16:25 -0800, Greg KH wrote:

> Mike, I've reverted this patch, and I don't see any references leaking.
> And, as your patch released the reference on the driver, and the
> module_add_driver() call would not grab a reference to the driver, only
> the module kobject, I don't see what you were trying to fix with this
> patch.
> 
> Do you have a test case that this fixes?

What it fixed for me was the hard hang reported below.

http://lkml.org/lkml/2007/2/16/96


	-Mike


