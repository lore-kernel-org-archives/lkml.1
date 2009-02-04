Return-Path: <linux-kernel-owner+w=401wt.eu-S1752393AbZBDArz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393AbZBDArz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbZBDAri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:47:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32817
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754092AbZBDArh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:47:37 -0500
Date: Tue, 03 Feb 2009 16:47:34 -0800 (PST)
Message-Id: <20090203.164734.76871204.davem@davemloft.net>
To: w@1wt.eu
Cc: zbr@ioremap.net, herbert@gondor.apana.org.au, jarkao2@gmail.com,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090203122535.GB8633@1wt.eu>
References: <20090203121209.GA9154@gondor.apana.org.au>
	<20090203121836.GA23300@ioremap.net>
	<20090203122535.GB8633@1wt.eu>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>
Date: Tue, 3 Feb 2009 13:25:35 +0100

> Well, FWIW, I've always observed better performance with 4k MTU (4080 to
> be precise) than with 9K, and I think that the overhead of allocating 3
> contiguous pages is a major reason for this.

With what hardware?  If it's with myri10ge, that driver uses page
frags so would not be using 3 contiguous pages even for jumbo frames.
