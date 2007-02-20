Return-Path: <linux-kernel-owner+w=401wt.eu-S965036AbXBTP2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965036AbXBTP2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965039AbXBTP2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:28:18 -0500
Received: from smtp.nokia.com ([131.228.20.172]:62800 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965036AbXBTP2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:28:17 -0500
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1171984555.3518.5.camel@hades.cambridge.redhat.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165449.5845.18238.sendpatchset@localhost.localdomain>
	 <20070219105445.GA16930@infradead.org> <1171976753.4039.27.camel@sauron>
	 <20070220145503.GC3170@thunk.org>
	 <1171984555.3518.5.camel@hades.cambridge.redhat.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 20 Feb 2007 17:24:15 +0200
Message-Id: <1171985055.4039.44.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Feb 2007 15:24:15.0988 (UTC) FILETIME=[2EAFBB40:01C75503]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-20 at 15:15 +0000, David Woodhouse wrote:
> On Tue, 2007-02-20 at 09:55 -0500, Theodore Tso wrote:
> > It appears that the reason why you are doing this is because you think
> > you need the (packed) attribute.  Not needed; Linux assumes all over
> > the place 16, 32, and 64 types are packed.  If Linux is ever compiled
> > on an architecture where this isn't true, the compiler will probably
> > need to be fixed so these assumptions are true, since all manner of
> > things will break.
> 
> No, the packedness is irrelevant -- the reason is just to catch all the
> places where you might otherwise forget to use byte-swapping accesses.

Bear in mind we share this header with user-space, so it is safer to use
packed as well as C99 types.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

