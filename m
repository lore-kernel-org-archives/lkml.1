Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbXA3XAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbXA3XAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbXA3XAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:00:21 -0500
Received: from gate.crashing.org ([63.228.1.57]:43431 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbXA3XAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:00:19 -0500
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 1/4] Add support to OProfile
	for	profiling Cell BE SPUs -- update
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Carl Love <cel@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <1170197398.5235.12.camel@dyn9047021078.beaverton.ibm.com>
References: <45BE4ED0.5030808@us.ibm.com> <45BE4F2A.5040702@us.ibm.com>
	 <20070130103924.GA14571@lst.de>
	 <1170197398.5235.12.camel@dyn9047021078.beaverton.ibm.com>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 09:59:57 +1100
Message-Id: <1170197997.26655.345.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-01-30 at 14:49 -0800, Carl Love wrote:
> Christoph:
> 
> In our earlier work on the PPU profiling patch, Benjamin Herrenschmidt
> said that we should remove macros that are only used once and just put
> the actual code in.  That is why the macros were removed. 

I've looked at the macros you remove and indeed, they look like stuff
you actually want to keep in macros. I don't have off the top of my head
the circumstances where I asked you to remove macros in the PPE code,
but I'm sure it was different.

Ben.


