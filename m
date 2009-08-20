Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbZHTMtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbZHTMtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754374AbZHTMtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:49:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:50018 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127AbZHTMtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:49:01 -0400
Message-ID: <4A8D4603.3060900@kernel.org>
Date: Thu, 20 Aug 2009 21:48:03 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Mark Lord <liml@rtr.ca>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: use single threaded work queue
References: <20090819112554.GY12579@kernel.dk> <4A8BE932.5090300@garzik.org>	 <20090819120458.GZ12579@kernel.dk> <4A8BECC2.2060607@rtr.ca>	 <20090819122320.GA12579@kernel.dk> <1250720545.4810.37.camel@pasglop> <4A8D45DF.8010307@gmail.com>
In-Reply-To: <4A8D45DF.8010307@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 20 Aug 2009 12:47:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Yes, it addresses different aspect of the concurrency problem.  Might
> be more suitable for ATA workqueues but definitely more costly to
> convert to.  Argh...
            ^ compared to Jens's lazy workqueue.

-- 
tejun
