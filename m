Return-Path: <linux-kernel-owner+w=401wt.eu-S1758353AbZCBKMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353AbZCBKMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 05:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbZCBKMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 05:12:40 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:47572 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022AbZCBKMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 05:12:40 -0500
Date: Mon, 2 Mar 2009 15:42:31 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Adrian Bunk <bunk@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Frank Seidel <frank@f-seidel.de>, kernalert.de@gmail.com
Subject: Re: [PATCH] lkdtm: reduce stack size
Message-ID: <20090302101231.GC7410@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <49AAE94E.8080308@suse.de> <20090302041148.GA7410@in.ibm.com> <1235987490.19757.4.camel@spike.firmix.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235987490.19757.4.camel@spike.firmix.at>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bernd,

On Mon, Mar 02, 2009 at 10:51:30AM +0100, Bernd Petrovitsch wrote:
> Hi!
> 
> On Mon, 2009-03-02 at 09:41 +0530, Ankita Garg wrote:
> > Hi Frank,
> > 
> > On Sun, Mar 01, 2009 at 09:00:14PM +0100, Frank Seidel wrote:
> > > From: Frank Seidel <frank@f-seidel.de>
> > > 
> > > Reduce stack memory footprint of lkdtm
> > > (recursive_loop). From 1024 bytes on i386 down
> > > to <10.
> > >
> > 
> > The intention here is infact to trigger a stack overflow. This module is
> > used to test kernel dumping mechanism like kdump. So the expectation is
> > that the kernel will dump as soon as the stack overflows.
> 
> That answers why the variable exists at all. It is only zeroed and never
> else used.
> Hmm, adding the above as a comment makes probably sense.
>

There is some text at the head of the module file that explains what the
module does and the usage, etc. I suppose that would be sufficient ?
 
-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   
