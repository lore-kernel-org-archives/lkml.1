Return-Path: <linux-kernel-owner+w=401wt.eu-S1760980AbXJDShC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760980AbXJDShC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 14:37:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbXJDSgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 14:36:53 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58483 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383AbXJDSgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 14:36:52 -0400
Date: Thu, 4 Oct 2007 13:36:29 -0500
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH 2/2]: PCI Error Recovery: Symbios SCSI First Failure
Message-ID: <20071004183629.GH4338@austin.ibm.com>
References: <20070420204114.GL31947@austin.ibm.com> <20070420204720.GM31947@austin.ibm.com> <20070926150216.GH3899@parisc-linux.org> <20070927220022.GC18686@austin.ibm.com> <20070927221031.GY3899@parisc-linux.org> <20070927233437.GF18686@austin.ibm.com> <20071001201247.GN12049@parisc-linux.org> <20071001224132.GH4338@austin.ibm.com> <20071002012730.GO12049@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002012730.GO12049@parisc-linux.org>
User-Agent: Mutt/1.5.11
From: linas@austin.ibm.com (Linas Vepstas)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 07:27:30PM -0600, Matthew Wilcox wrote:
> 
> The thing to remember is that sym2 is in transition from being a dual
> BSD/Linux driver to being a purely Linux driver. 

I was wondering about that; couldn't tell if the split in the code
was historical, or being intentionally maintained.

> > My gut instinct is to say "ack", although prudence dictates that 
> > I should test first. Which might take a few days...
> 
> Fine by me.  

I tested the patch, it worked great. It also seemed to recover 
much more quickly -- so quickly, in fact, that I thought something 
had gone wrong.

I reviewed it one more time, it really does look good. A formal
submission and acked by's at earliest convenience would be good. 

--linas

