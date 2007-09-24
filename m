Return-Path: <linux-kernel-owner+w=401wt.eu-S1761326AbXIXSRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761326AbXIXSRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760265AbXIXSQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:16:50 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:44442 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759095AbXIXSQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:16:49 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 24 Sep 2007 14:15:12 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Christoph Hellwig <hch@infradead.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 4/7] Linux Kernel Markers - Architecture Independent Code
In-Reply-To: <20070924174817.GB1608@infradead.org>
Message-ID: <Pine.LNX.4.64.0709241413450.22210@localhost.localdomain>
References: <20070924164950.006047409@polymtl.ca> <20070924165427.717587684@polymtl.ca>
 <20070924174817.GB1608@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007, Christoph Hellwig wrote:

> static inline void __mark_check_format(const char *fmt, ...)
> 		__attribute__ ((format (printf, 1, 2)))
> {
> }

the header file compiler-gcc.h defines the shorter macro "__printf".
is it worth encouraging its use, or does it matter?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
