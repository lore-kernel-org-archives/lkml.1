Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993AbXA3XDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993AbXA3XDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbXA3XDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:03:06 -0500
Received: from gate.crashing.org ([63.228.1.57]:53596 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbXA3XDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:03:05 -0500
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 1/4] Add support to OProfile for
	profiling Cell BE SPUs -- update
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
Date: Wed, 31 Jan 2007 09:57:26 +1100
Message-Id: <1170197846.26655.342.camel@localhost.localdomain>
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

Heh... there is a balance to be found... In some cases, inline functions
might be better too.

Ben.


