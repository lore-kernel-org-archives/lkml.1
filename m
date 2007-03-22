Return-Path: <linux-kernel-owner+w=401wt.eu-S932515AbXCVWCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515AbXCVWCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934240AbXCVWCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:02:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:39481 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562AbXCVWCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:02:48 -0400
Subject: Re: [PATCH 0/21] MSI rework
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, daniel.e.wolstenholme@intel.com
In-Reply-To: <20070322190834.GA14802@kroah.com>
References: <1174560686.307511.956605711793.qpush@cradle>
	 <m1lkhp8gqx.fsf@ebiederm.dsl.xmission.com>
	 <20070322190834.GA14802@kroah.com>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 09:02:16 +1100
Message-Id: <1174600936.10836.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > i.e.  First the simple bug fixes that should purely be restructure of
> > msi.c with no affect on anything outside of it.
> > 
> > And then get into the architecture enhancements.
> 
> I agree, care to break these down into a smaller series of patches that
> can go into -mm for testing?

I don't see the point in breaking the serie... you can bisect half way
through if necessary... it's made of small patches that are done, afaik,
in such a way that the whole thing should still work at any level in the
serie.

The serie just expresses the dependency between them.

Ben.


