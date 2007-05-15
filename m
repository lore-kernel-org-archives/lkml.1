Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbXEOWGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbXEOWGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 18:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbXEOWGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 18:06:16 -0400
Received: from www.osadl.org ([213.239.205.134]:42892 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754996AbXEOWGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 18:06:16 -0400
Subject: Re: clockevent questions
From: Thomas Gleixner <tglx@linutronix.de>
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <38b2ab8a0705150147s4ce72914qfa30d543ed8a4839@mail.gmail.com>
References: <38b2ab8a0705120754l281f54eevd1e91e2f01fff6f2@mail.gmail.com>
	 <1178982892.22481.183.camel@localhost.localdomain>
	 <38b2ab8a0705121313k37be467cy55402b490101ac9c@mail.gmail.com>
	 <1179001391.22481.216.camel@localhost.localdomain>
	 <38b2ab8a0705150147s4ce72914qfa30d543ed8a4839@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 16 May 2007 00:10:14 +0200
Message-Id: <1179267014.12838.38.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francis,

On Tue, 2007-05-15 at 10:47 +0200, Francis Moreau wrote:
> My question is about the clock resolution field which is equal to 1ns.
> How is this possible since my timer's frequency is only 100Mhz ?

you are right. It is a bit strange. The resolution info is not really
reflecting the clock event source capability. I look if there is a sane
solution for that.

	tglx


