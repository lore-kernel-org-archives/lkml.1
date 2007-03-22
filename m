Return-Path: <linux-kernel-owner+w=401wt.eu-S1161173AbXCVWbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161173AbXCVWbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 18:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161172AbXCVWbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 18:31:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:40429 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161169AbXCVWbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 18:31:34 -0400
Subject: Re: [PATCH 0/21] MSI rework
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, daniel.e.wolstenholme@intel.com
In-Reply-To: <20070322220837.GD20713@kroah.com>
References: <1174560686.307511.956605711793.qpush@cradle>
	 <m1lkhp8gqx.fsf@ebiederm.dsl.xmission.com>
	 <20070322190834.GA14802@kroah.com>
	 <1174600936.10836.53.camel@localhost.localdomain>
	 <20070322220837.GD20713@kroah.com>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 09:31:15 +1100
Message-Id: <1174602675.10836.60.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Ok, then which patches in the series should be acceptable to take right
> now for 2.6.22?  The "clean up the BUG" ones?

I'd say 1...8 (BUG cleanups and removing msi_cache) looks to be on the
safe side to me, though of course, some review by Eric & a bit of
testing would be welcome regardless :-)

The others could go into -mm right away I suppose (or rather as soon as
Eric gets a chance to verify they don't break his test setups as I think
he can test MSI-X) and we can pour them into mainline one by one if
necessary as they get hammered / verified.

Cheers,
Ben.


