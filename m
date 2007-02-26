Return-Path: <linux-kernel-owner+w=401wt.eu-S964934AbXBZKLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934AbXBZKLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 05:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965039AbXBZKLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 05:11:10 -0500
Received: from smtp.nokia.com ([131.228.20.172]:41409 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964934AbXBZKLJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 05:11:09 -0500
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070225055011.GA8616@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165449.5845.18238.sendpatchset@localhost.localdomain>
	 <20070219105445.GA16930@infradead.org> <1171976753.4039.27.camel@sauron>
	 <20070225055011.GA8616@infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 26 Feb 2007 12:09:06 +0200
Message-Id: <1172484546.4039.73.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 26 Feb 2007 10:09:06.0805 (UTC) FILETIME=[2669E250:01C7598E]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070226120620-2BF7ABB0-49B8A1A5/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-25 at 05:50 +0000, Christoph Hellwig wrote:
> > I do not see what is the problem with this. Please, refine.
> 
> global variables are very bad for code maintainability and understanadbility.
> So we usually try to avoid them if possible and make them static to a
> single file and provide proper accessors for allowed actions on them.

I will think about this, but at the first glance it looks like it will
be too much to provide distinct functions to assces the current number
of attached UBI devices. I can make it inline, but then exporting the
variable will be needed anyway.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

