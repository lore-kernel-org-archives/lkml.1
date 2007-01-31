Return-Path: <linux-kernel-owner+w=401wt.eu-S932378AbXAaIsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbXAaIsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 03:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932367AbXAaIsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 03:48:40 -0500
Received: from verein.lst.de ([213.95.11.210]:56358 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378AbXAaIsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 03:48:39 -0500
Date: Wed, 31 Jan 2007 09:47:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Carl Love <cel@us.ibm.com>, Christoph Hellwig <hch@lst.de>,
       linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 1/4] Add support to OProfile for profiling Cell BE SPUs -- update
Message-ID: <20070131084721.GC5596@lst.de>
References: <45BE4ED0.5030808@us.ibm.com> <45BE4F2A.5040702@us.ibm.com> <20070130103924.GA14571@lst.de> <1170197398.5235.12.camel@dyn9047021078.beaverton.ibm.com> <1170197846.26655.342.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170197846.26655.342.camel@localhost.localdomain>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 31, 2007 at 09:57:26AM +1100, Benjamin Herrenschmidt wrote:
> On Tue, 2007-01-30 at 14:49 -0800, Carl Love wrote:
> > Christoph:
> > 
> > In our earlier work on the PPU profiling patch, Benjamin Herrenschmidt
> > said that we should remove macros that are only used once and just put
> > the actual code in.  That is why the macros were removed. 
> 
> Heh... there is a balance to be found... In some cases, inline functions
> might be better too.

Well, unless there's a very good reasons against it (token pasting,
header pollution) inlines are always preferable over macros, but I
didn't want to bring that issue up aswell..
