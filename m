Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbXLUTNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbXLUTNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 14:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbXLUTNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 14:13:06 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:55854 "EHLO
	mk-filter-2-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753278AbXLUTNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 14:13:04 -0500
X-Trace: 650942910/mk-filter-2.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.80
X-SBRS: None
X-RemoteIP: 81.1.89.80
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAKCea0dRAVlQ/2dsb2JhbACBV6g2
Subject: Re: [PATCH - SH/Dreamcast] Add support for GD-Rom device
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <20071221121441.GB11583@kernel.dk>
References: <8b67d60712201559h5dbb2a17q8f16223b26b88006@mail.gmail.com>
	 <8b67d60712201607k66d67fa2la8b21fc698fdb3ab@mail.gmail.com>
	 <20071221121441.GB11583@kernel.dk>
Content-Type: text/plain
Date: Fri, 21 Dec 2007 19:12:39 +0000
Message-Id: <1198264359.7235.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-21 at 13:14 +0100, Jens Axboe wrote:

> 
> What is pages doing in gdrom_request()?
> 

As the device doesn't do scatter-gather I've set
blk_queue_max_segment_size to 1 and am not bothering with pages - is
that wrong?

