Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbZBFJto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbZBFJto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 04:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZBFJtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 04:49:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39629
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753014AbZBFJtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 04:49:35 -0500
Date: Fri, 06 Feb 2009 01:49:31 -0800 (PST)
Message-Id: <20090206.014931.135139791.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: herbert@gondor.apana.org.au, zbr@ioremap.net, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090206094253.GB4879@ff.dom.local>
References: <20090206091034.GA4879@ff.dom.local>
	<20090206.011722.41272682.davem@davemloft.net>
	<20090206094253.GB4879@ff.dom.local>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Fri, 6 Feb 2009 09:42:53 +0000

> I hope you're right, but on the other hand, people don't use slob by
> default.

The use is different, so it's a bad comparison, really.

SLAB has to satisfy all kinds of object lifetimes, all kinds
of sizes and use cases, and perform generally well in all
situations with zero knowledge about usage patterns.

Networking is strictly the opposite of that set of requirements.  We
know all of these parameters (or their ranges) and can on top of that
control them if necessary.
