Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbYACTw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbYACTw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 14:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYACTwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 14:52:16 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:41764 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751211AbYACTwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 14:52:15 -0500
Date: Fri, 4 Jan 2008 01:22:01 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: hbabu@us.ibm.com, lkml <linux-kernel@vger.kernel.org>,
       kexec@lists.infradead.org, rjw@sisk.pl
Subject: Re: kexec refuses to boot latest -mm
Message-ID: <20080103195201.GC6392@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071228124532.GB32643@linux.vnet.ibm.com> <20071228142739.GA4560@redhat.com> <20071229054113.GB17426@linux.vnet.ibm.com> <20071231150843.GB27060@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071231150843.GB27060@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 10:08:43AM -0500, Vivek Goyal wrote:
> On Sat, Dec 29, 2007 at 11:11:13AM +0530, Dhaval Giani wrote:
> > On Fri, Dec 28, 2007 at 09:27:39AM -0500, Vivek Goyal wrote:
> > > On Fri, Dec 28, 2007 at 06:15:32PM +0530, Dhaval Giani wrote:
> > > > Hi Vivek,
> > > > 
> > > > I can't seem to get the latest -mm (2.6.24-rc6-mm1) to boot with
> > > > kexec. It just gets stuck at "Starting new kernel".
> > > > 
> > > > It does boot normally when booted as the first kernel.
> > > > 
> > > > Any hints debugging? (x86 architecture)
> > > 
> > > I generally try few things.
> > > 
> > > - Specify earlyprintk= parameter for second kernel and see if control
> > >   is reaching to second kernel.
> > > 
> > > - Otherwise specify --console-serial parameter on "kexec -l" commandline
> > >   and it should display a message "I am in purgatory" on serial console.
> > >   This will just mean that control has reached at least till purgatory.
> > > 
> > 
> > Ok, so it reaches till here. I get "I'm in purgatory" on the console.
> 
> One more thing. Is 2.6.24-rc6 working properly?
> 

2.6.24-rc5 boots, so does 2.6.24-rc5-mm1. 2.6.24-rc6 does not boot, nor
does 2.6.24-rc6-mm1. Its a regression.

i will add more outbs and respond back and try a bisect if that does not
help.

Thanks
-- 
regards,
Dhaval
