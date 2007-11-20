Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbXKTA5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbXKTA5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbXKTA5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:57:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54711
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752515AbXKTA5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:57:09 -0500
Date: Mon, 19 Nov 2007 16:57:08 -0800 (PST)
Message-Id: <20071119.165708.37213607.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk
Subject: Re: SCSI breakage on non-cache coherent architectures
From: David Miller <davem@davemloft.net>
In-Reply-To: <1195520101.6970.28.camel@pasglop>
References: <1195518864.6970.23.camel@pasglop>
	<20071119.164611.64664648.davem@davemloft.net>
	<1195520101.6970.28.camel@pasglop>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 20 Nov 2007 11:55:01 +1100

> BTW. What is the status nowadays with skb's ?

Good question.

Some drivers are problematic (or were) because they put
DMA descriptor chaining information at the head of the
buffer, but those have been fixed either to use alternate
descriptor ring facilities or make the proper DMA sync
calls.
