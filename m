Return-Path: <linux-kernel-owner+w=401wt.eu-S1760964AbXIQJM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760964AbXIQJM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759615AbXIQJKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 05:10:44 -0400
Received: from verein.lst.de ([213.95.11.210]:47079 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759051AbXIQJKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 05:10:42 -0400
From: Torsten Duwe <duwe@lst.de>
Organization: LST e.V.
To: bob.montgomery@hp.com
Subject: Re: RFC: incorrect results from RTC reading method
Date: Mon, 17 Sep 2007 11:10:08 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <1189715635.12439.62.camel@amd.troyhebe>
In-Reply-To: <1189715635.12439.62.camel@amd.troyhebe>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709171110.09140.duwe@lst.de>
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2007, Bob Montgomery wrote:

> I think any method for reading the RTC must consider the (Update In
> Progress) flag to avoid bogus results.

This is a really good idea, I wonder if this has been tried before...
But seriously, the RTC driver does that, and the boot process used to do that, 
too.

	Torsten
