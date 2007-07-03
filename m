Return-Path: <linux-kernel-owner+w=401wt.eu-S1759256AbXGCHMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759256AbXGCHMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 03:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbXGCHMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 03:12:43 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:34285 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756465AbXGCHMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 03:12:42 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [linux-usb-devel] [PATCH 3/4] usb: allocated usb releated dma buffer with?kmalloc_node
Date: Tue, 3 Jul 2007 09:12:39 +0200
User-Agent: KMail/1.9.7
Cc: linux-usb-devel@lists.sourceforge.net, Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
References: <200706291326.43563.yinghai.lu@sun.com> <200707030823.07815.oliver@neukum.org> <20070703070312.GA19924@kroah.com>
In-Reply-To: <20070703070312.GA19924@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707030912.40185.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 3. Juli 2007 schrieb Greg KH:
> > > Ok, so two drivers might need this, but not the whole usb core, right?
> > 
> > If those two drivers need the extended allocator, why not use it where
> > it is beneficial, even if the benefit is small?
> 
> What is the benefit?  Speed isn't an issue here, so what is?

Speed is always an issue. Every cycle used in the kernel is lost to
user space.

	Regards
		Oliver

