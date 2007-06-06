Return-Path: <linux-kernel-owner+w=401wt.eu-S934818AbXFFQF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934818AbXFFQF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbXFFQFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:05:15 -0400
Received: from havoc.gtf.org ([69.61.125.42]:48911 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbXFFQFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:05:13 -0400
Date: Wed, 6 Jun 2007 12:05:11 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, akpm@linux-foundation.org,
       david@dgreaves.com, jean.luc.coulon@gmail.com, jgarzik@pobox.com,
       michal.k.k.piotrowski@gmail.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH] sata_promise: use TF interface for polling NODATA commands
Message-ID: <20070606160511.GA23143@havoc.gtf.org>
References: <200706052131.l55LVkYN000191@harpo.it.uu.se> <20070605215256.GT31565@havoc.gtf.org> <46665AB5.6040508@gmail.com> <20070606102122.GD29122@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606102122.GD29122@htj.dyndns.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


FYI to all -- 

As a reminder. the Promise hardware programs registers when it receives
a SET FEATURES - XFER MODE.

If data transfer is occurring on OTHER ports at the time this is issued,
then data corruption is guaranteed to occur.  Polling will not fix this
problem -- all ports need to be inactive, when a SET FEATURES - XFER
MODE command is issued for any port.

	Jeff



