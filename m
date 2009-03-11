Return-Path: <linux-kernel-owner+w=401wt.eu-S1753650AbZCKAiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbZCKAiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 20:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbZCKAiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 20:38:06 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46726 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753029AbZCKAiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 20:38:05 -0400
Date: Wed, 11 Mar 2009 00:37:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Timur Tabi <timur@freescale.com>, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, jirislaby@gmail.com, peterz@infradead.org,
       will.newton@gmail.com, hancockrwd@gmail.com, jeremy@goop.org
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
Message-ID: <20090311003756.25ffa6f4@lxorguk.ukuu.org.uk>
In-Reply-To: <1236729711.7086.28.camel@pasglop>
References: <1236699004-1863-1-git-send-email-timur@freescale.com>
	<20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>
	<1236729711.7086.28.camel@pasglop>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A simple fact of life is that drivers -will- do that sort spinning. They
> don't always have a choice. Now do we want all drivers to do it
> differently and get it wrong (such as not having timeouts etc...) or do
> we provide a helper that has the added advantage of allowing us a lot
> more easily to audit them ?

Given the proposed helper isn't a sane default for x86 I think it needs a
good deal more work. It also hides details like that timing which is bad
sometimes.

> I think it's all benefit to move that sort of cruft to a generic helper
> like that in the long run.

Perhaps - but the helper needs to be right
