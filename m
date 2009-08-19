Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZHSWXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZHSWXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 18:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbZHSWXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 18:23:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:33259 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbZHSWXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 18:23:37 -0400
Subject: Re: [PATCH] libata: use single threaded work queue
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mark Lord <liml@rtr.ca>, Jeff Garzik <jeff@garzik.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com
In-Reply-To: <20090819122320.GA12579@kernel.dk>
References: <20090819112554.GY12579@kernel.dk> <4A8BE932.5090300@garzik.org>
	 <20090819120458.GZ12579@kernel.dk> <4A8BECC2.2060607@rtr.ca>
	 <20090819122320.GA12579@kernel.dk>
Content-Type: text/plain
Date: Thu, 20 Aug 2009 08:22:25 +1000
Message-Id: <1250720545.4810.37.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 14:23 +0200, Jens Axboe wrote:
> Well, that's the same thread pool suggestion that Jeff came up with.
> And
> I agree, that's a nicer long term solution (it's also how the per-bdi
> flushing replacement works). The problem with that appears to be that
> any suggested patchset for thread pools spiral into certain "but what
> color should it be?!" death.
> 
> I'll try and work up a simple create_threadpool() implementation, we
> can
> literally cut away hundreds of threads with that.

Don't we have one already ? Dave Howells slow_work or such ?

Ben.


