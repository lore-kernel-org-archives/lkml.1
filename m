Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbXLKTCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbXLKTCR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 14:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXLKTCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 14:02:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56237
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751784AbXLKTCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 14:02:04 -0500
Date: Tue, 11 Dec 2007 11:02:02 -0800 (PST)
Message-Id: <20071211.110202.186865875.davem@davemloft.net>
To: andi@firstfloor.org
Cc: nashif@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071211185317.GA21864@one.firstfloor.org>
References: <p7363z5nlo8.fsf@bingen.suse.de>
	<475ED912.609@linux.intel.com>
	<20071211185317.GA21864@one.firstfloor.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Tue, 11 Dec 2007 19:53:17 +0100

> Ok but saving oops is such a useful facility that we'll probably
> need to think about implementing SOAP in the kernel.

Ummm, no.

UDP is stateless, a stripped down copy of TCP we simply
do not need.  We also do not need XML in the kernel either.

If they want to support things like this they should do it in the
firmware of the management entity like every other sane server
platform does these days.

The console and OOPS messages should go over an extremely resilient
transport which is as simple as possible which usually means shared
memory or I/O memory with some simple handshake or doorbell.  This
gets it to the management entity board or whatever, and how it gets
from there to the remote system is it's business not that of the
kernel.

Not TCP, and definitely not this XML SOAP crap.
