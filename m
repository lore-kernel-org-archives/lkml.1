Return-Path: <linux-kernel-owner+w=401wt.eu-S933765AbZLOVr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765AbZLOVr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932949AbZLOVrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:47:53 -0500
Received: from aglcosbs04.cos.agilent.com ([192.25.218.38]:47018 "EHLO
	aglcosbs04.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932892AbZLOVrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:47:51 -0500
Message-ID: <4B2803D8.10704@agilent.com>
Date: Tue, 15 Dec 2009 13:47:04 -0800
From: Earl Chew <earl_chew@agilent.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Hans J. Koch" <hjk@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, hugh <hugh@veritas.com>, linux-mm <linux-mm@kvack.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
References: <1228379942.5092.14.camel@twins> <4B22DD89.2020901@agilent.com> <20091214192322.GA3245@bluebox.local> <4B27905B.4080006@agilent.com> <20091215210002.GA2432@local>
In-Reply-To: <20091215210002.GA2432@local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Dec 2009 21:47:08.0773 (UTC) FILETIME=[26994950:01CA7DD0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans J. Koch wrote:
> Sorry, I think I wasn't clear enough: The current interface for static
> mappings shouldn't be changed. Dynamically added mappings need a new
> interface.

Thanks for the quick reply.

Are you ok with changes to the (internal) struct uio_device ?

This content of this structure is only known to uio.c and only its
name is exposed through the client visible uio_driver.h.

Earl



