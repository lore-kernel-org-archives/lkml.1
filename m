Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbYIZG0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbYIZG0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 02:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYIZG0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 02:26:37 -0400
Received: from smtp.nokia.com ([192.100.122.230]:48097 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbYIZG0g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 02:26:36 -0400
Subject: Re: [ANNOUNCE] [PATCH] [MTD] Flex-OneNAND MTD Driver available.
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Kyungmin Park <kmpark@infradead.org>
Cc: apgmoorthy <moorthy.apg@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       linux-mtd@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <9c9fda240809252230s6373acf8v4dd2b942eba360a7@mail.gmail.com>
References: <19198934.52871221827459790.JavaMail.weblogic@epml16>
	 <9c9fda240809220011w49c0875q804f836550ff3476@mail.gmail.com>
	 <000001c91e42$1aa86c50$3dd66c6b@sisodomain.com>
	 <9c9fda240809251731y48272a63j988e0001dc50d78@mail.gmail.com>
	 <1222404711.5012.5.camel@sauron>
	 <9c9fda240809252230s6373acf8v4dd2b942eba360a7@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 26 Sep 2008 09:26:09 +0300
Message-Id: <1222410369.5012.9.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 26 Sep 2008 06:26:13.0133 (UTC) FILETIME=[C5D8FBD0:01C91FA0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-09-26 at 14:30 +0900, Kyungmin Park wrote:
> Thank you for your kind comments.
> 
> Yes that's I concerned it breaks the other NAND ABI. Actually In
> OneNAND it doesn't use eccpos since OneNAND controller handle all ECC
> functions. we don't need to concern it.

Right.

> As pages are bigger, it requires more eccpos and other fields are
> similar. we need more flexible filed definitions.

Right.

> Well how do you think that at this time it only describes the 64 bytes
> only for temporarily and next time it adds remaining parts if it is
> really needed.

Well, it is not very nice, but I guess it should be OK for this case,
because people are not supposed to look at OOB of MLC OneNAND anyway. So
I would go this way, although I'm not sure dwmw2 would agree on this.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

