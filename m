Return-Path: <linux-kernel-owner+w=401wt.eu-S932453AbXBSS2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbXBSS2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 13:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932456AbXBSS2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 13:28:41 -0500
Received: from smtp.nokia.com ([131.228.20.172]:24518 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453AbXBSS2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 13:28:40 -0500
Subject: Re: [PATCH 00/44 take 2] [UBI] Unsorted Block Images
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
In-Reply-To: <20070219105009.GA15792@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070219105009.GA15792@infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 19 Feb 2007 19:44:16 +0200
Message-Id: <1171907056.14817.70.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Feb 2007 17:44:17.0388 (UTC) FILETIME=[93E5E2C0:01C7544D]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070219194139-498E4BB0-672E6FD3/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 10:50 +0000, Christoph Hellwig wrote:
> I think this is the wrong approach.  For one thing the unit terms is
> rather foregin in Linux

I would rather disagree. Subjective. Unit is a generic word, just like
subsystem. Unit-tests for example is a widespread word it refer to
internal units of a big system.

> , and second this one header file "unit" is
> definitly too much.

It is .c + .h.

Why definitely, where is the definition? I appreciate your opinion, but
do not want any endless discussion about "how the life has to go",
though.

>   Normally you'd have as little as possible and at
> most four:
> 
>  (1) internal definitions of the driver
>  (2) external kernel interface of the driver if nessecary
>  (3) user interface of the driver if nessecary
>  (4) ondisk structure if nessecary

Where does this rather restrictive model come from? What does it mean in
practice for UBI? Please, be more specific.

> Also please make sure you submit patches at this driver level.  You really
> want one git commit per driver that is totally self-contained.  If nessecary
> you'd split this into multiple patches if a single one would be bigger then
> the message size limit.

Please, refine what does this exactly mean. I do not see how I should
have sent it, sorry. OK, I've separated external headers, JFFS2 support,
build stuff. What next?

And I sent it just for review, as you requested, I assumed that for the
pull we have git, and I specified the URL.

Thanks,
Artem.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

