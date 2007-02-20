Return-Path: <linux-kernel-owner+w=401wt.eu-S965043AbXBTPWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965043AbXBTPWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965044AbXBTPWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:22:46 -0500
Received: from smtp.nokia.com ([131.228.20.173]:50155 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965043AbXBTPWp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:22:45 -0500
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Theodore Tso <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070220145503.GC3170@thunk.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165449.5845.18238.sendpatchset@localhost.localdomain>
	 <20070219105445.GA16930@infradead.org> <1171976753.4039.27.camel@sauron>
	 <20070220145503.GC3170@thunk.org>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 Feb 2007 17:21:48 +0200
Message-Id: <1171984908.4039.42.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Feb 2007 15:21:48.0395 (UTC) FILETIME=[D6B6D3B0:01C75502]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070220171840-7CE73BB0-7490B04A/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-20 at 09:55 -0500, Theodore Tso wrote:
> > What do you mean? It is internal version just for future help: if we
> > develop incompatible UBI2 the old UBI will reject the new images.
> 
> In that case it's not an *implementation* version number, but rather
> an on-disk *format* version number. 

True, will refine the comment.

>  There's a difference.  It's also
> often not used much, since another way of dealing with the problem is
> to mark major each on-disk version with a different magic number.

The advantage of version is that UBI can distinguish between garbage and
incompatible image. If I meet wrong magic - what is it - rubbish,
corrupted header? Should I run recovery procedure? Having version is
just cleaner.

> Why isn't this being done via #define?  It's not like this is any kind
> of an enumerated type, especially since it's being installed into a
> 32bit type, and not even an enum type.

Will be fixed, thanks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

