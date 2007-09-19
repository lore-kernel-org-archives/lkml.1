Return-Path: <linux-kernel-owner+w=401wt.eu-S1762875AbXISShi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762875AbXISShi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762398AbXISShZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:37:25 -0400
Received: from rgminet02.oracle.com ([148.87.113.119]:54865 "EHLO
	rgminet02.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762655AbXISShX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:37:23 -0400
X-Greylist: delayed 4759 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2007 14:37:23 EDT
Date: Wed, 19 Sep 2007 09:52:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Wilder <dwilder@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [Patch 1/2] Trace code and documentation (updated)
Message-Id: <20070919095223.83bd8226.randy.dunlap@oracle.com>
In-Reply-To: <20070919162018.GA16237@infradead.org>
References: <1190177218.3190.18.camel@lc4eb748232119.ibm.com>
	<p736427vz00.fsf@bingen.suse.de>
	<46F12ED7.3060605@us.ibm.com>
	<20070919162018.GA16237@infradead.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 17:20:18 +0100 Christoph Hellwig wrote:

> On Wed, Sep 19, 2007 at 07:14:47AM -0700, David Wilder wrote:
> > I agree with you; however, this is in the example code in the 
> > Documentation directory,  It is not part of the trace code.  The example 
> > was just meant to be a demonstration of how the interface works.
> 
> So we tell people to write bad code?  Wonderful..
> 
> And while we're at it can we please stop the dumb idea to put example
> code into Documentation?  If example code doesn't get build during a
> make oldconfig it will bitrot real fast and not be useful at all.


That's why they exmaples should not be hidden/embedded in .txt files;
they should be standalone .c files with makefiles etc.

I've built and corrected several of them, but they would be more
likely to be kept up-to-date if they are more available in standalone
files.

and they can be taken out of Documentation/ whenever they go into
util-linux-ng or elsewhere.  Let's get the order correct.

---
~Randy
