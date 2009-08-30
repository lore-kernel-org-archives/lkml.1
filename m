Return-Path: <linux-kernel-owner+w=401wt.eu-S1753324AbZH3CtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbZH3CtE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 22:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZH3CtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 22:49:04 -0400
Received: from rtr.ca ([76.10.145.34]:46274 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbZH3CtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 22:49:03 -0400
Message-ID: <4A99E89E.9020204@rtr.ca>
Date: Sat, 29 Aug 2009 22:49:02 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com, matthew@wil.cx,
       dwmw2@infradead.org
Subject: Re: [PATCH 6/7] block: allow large discard requests
References: <20090829230332.017137693@bombadil.infradead.org> <20090829231122.302813585@bombadil.infradead.org>
In-Reply-To: <20090829231122.302813585@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pardon my cursory review, but I don't see where this
patch set allows for more than a single extent/range
of sectors per TRIM command.

If it still does not group many extents into a single TRIM,
then it will be far to slow to be useful at all for SATA.

But if it does.. my apologies.  :)
