Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbXLKRFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbXLKRFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbXLKRFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:05:11 -0500
Received: from mail.suse.de ([195.135.220.2]:33016 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbXLKRFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:05:09 -0500
Date: Tue, 11 Dec 2007 09:04:00 -0800
From: Greg KH <gregkh@suse.de>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       kay.sievers@vrfy.org
Subject: Re: 2.6.22.14 oops msg with commvault galaxy ?
Message-ID: <20071211170400.GA4861@suse.de>
References: <20071207151113.e9841341.akpm@linux-foundation.org> <20071207171455.b2eecb60.randy.dunlap@oracle.com> <F1D642E5A91BC94D9504EC83AE19E6B0015201AF@ecqcmtlmail3.quebec.int.ec.gc.ca> <F1D642E5A91BC94D9504EC83AE19E6B0015201B1@ecqcmtlmail3.quebec.int.ec.gc.ca> <20071210091501.deed38fa.randy.dunlap@oracle.com> <20071211145437.GA15617@linux.vnet.ibm.com> <20071211164319.GA14783@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071211164319.GA14783@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 10:13:19PM +0530, Dhaval Giani wrote:
> On Tue, Dec 11, 2007 at 08:24:37PM +0530, Dhaval Giani wrote:
> > On Mon, Dec 10, 2007 at 09:15:01AM -0800, Randy Dunlap wrote:
> > > On Mon, 10 Dec 2007 09:03:17 -0500 Fortier,Vincent [Montreal] wrote:
> > > 
> > > Ingo, can you look at this, please?
> > > Vincent is getting oopses on 2.6.22.14-cfs-etch.
> > > 
> > 
> > Hi,
> > 
> > We are looking into this bug now. I believe that the patch at
> > http://marc.info/?l=linux-kernel&m=119404922603293 should help.
> > 
> > I am working with Kay to get this ported.
> > 
> 
> Hi Vincent,
> 
> Does the following patch help?
> 
> Kay/Greg, could you please review and add your Signed-off-by(s) as
> required?

Um, why?  What is this patch for?  Where is it to be sent, to Linus for
2.6.24-final?  Or to the -stable tree?

> This is basically a port of the patch at
> http://marc.info/?l=linux-kernel&m=119404922603293

Yeah, but that patch needs some other core kobject changes, right?

What exactly are you trying to fix here, the fact that this code never
even worked?

And, please, we need some documentation for Documenatation/ABI/ on
exactly what these sysfs files and tree is for.  Please add that now for
Linus's tree.

confused,

greg k-h
