Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbZBDAqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbZBDAqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbZBDAqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:46:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32796
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbZBDAqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:46:13 -0500
Date: Tue, 03 Feb 2009 16:46:09 -0800 (PST)
Message-Id: <20090203.164609.160183741.davem@davemloft.net>
To: zbr@ioremap.net
Cc: jarkao2@gmail.com, herbert@gondor.apana.org.au, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090203111012.GA16878@ioremap.net>
References: <20090202.235017.253437221.davem@davemloft.net>
	<20090203094108.GA4639@ff.dom.local>
	<20090203111012.GA16878@ioremap.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeniy Polyakov <zbr@ioremap.net>
Date: Tue, 3 Feb 2009 14:10:12 +0300

> NTA tried to solve this by not allowing to free the data allocated on
> the different CPU, contrary to what SLAB does. Modulo cache coherency
> improvements,

This could kill performance on NUMA systems if we are not careful.

If we ever consider NTA seriously, these issues would need to
be performance tested.
