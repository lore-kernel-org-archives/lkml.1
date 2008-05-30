Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbYE3BX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbYE3BX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 21:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYE3BXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 21:23:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:47129 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbYE3BXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 21:23:21 -0400
Subject: Re: RFC: Moving firmware blobs out of the kernel.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1212077700.26088.83.camel@shinybook.infradead.org>
References: <1211995212.3445.52.camel@localhost.localdomain>
	 <20080528.225826.40264516.davem@davemloft.net>
	 <1212041839.8888.38.camel@pasglop>  <20080529124548.GC8065@mit.edu>
	 <1212077700.26088.83.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Fri, 30 May 2008 11:22:59 +1000
Message-Id: <1212110579.15633.12.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 .../...

> By the time the kernel summit comes around, we should have made decent
> progress on moving _all_ the firmware blobs to the firmware/ directory.
> And at that point I'd like to remove them completely, to a separate git
> tree and tarball. Those who really want to build them in to their static
> kernel would still be able to, but it wouldn't be the default behaviour.

Pretty much on line with others: I like most of what you propose
-except- having the firmwares distributed in a separate git tree. I much
prefer having them still in the main kernel, though distro can choose
not to do so more easily if they are in a separate directory.

Ben.


