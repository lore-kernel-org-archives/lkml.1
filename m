Return-Path: <linux-kernel-owner+w=401wt.eu-S1753379AbYADM2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbYADM2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 07:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYADM2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 07:28:39 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:45689 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751754AbYADM2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 07:28:38 -0500
Date: Fri, 4 Jan 2008 17:58:16 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Vivek Goyal <vgoyal@redhat.com>, hbabu@us.ibm.com,
       lkml <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org
Subject: Re: kexec refuses to boot latest -mm
Message-ID: <20080104122816.GF4514@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071228124532.GB32643@linux.vnet.ibm.com> <20071231150843.GB27060@redhat.com> <20080103195201.GC6392@linux.vnet.ibm.com> <200801032242.01425.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801032242.01425.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2008 at 10:42:00PM +0100, Rafael J. Wysocki wrote:
> On Thursday, 3 of January 2008, Dhaval Giani wrote:
> > On Mon, Dec 31, 2007 at 10:08:43AM -0500, Vivek Goyal wrote:
> > > On Sat, Dec 29, 2007 at 11:11:13AM +0530, Dhaval Giani wrote:
> > > > On Fri, Dec 28, 2007 at 09:27:39AM -0500, Vivek Goyal wrote:
> > > > > On Fri, Dec 28, 2007 at 06:15:32PM +0530, Dhaval Giani wrote:
> > > > > > Hi Vivek,
> > > > > > 
> > > > > > I can't seem to get the latest -mm (2.6.24-rc6-mm1) to boot with
> > > > > > kexec. It just gets stuck at "Starting new kernel".
> > > > > > 
> > > > > > It does boot normally when booted as the first kernel.
> > > > > > 
> > > > > > Any hints debugging? (x86 architecture)
> > > > > 
> > > > > I generally try few things.
> > > > > 
> > > > > - Specify earlyprintk= parameter for second kernel and see if control
> > > > >   is reaching to second kernel.
> > > > > 
> > > > > - Otherwise specify --console-serial parameter on "kexec -l" commandline
> > > > >   and it should display a message "I am in purgatory" on serial console.
> > > > >   This will just mean that control has reached at least till purgatory.
> > > > > 
> > > > 
> > > > Ok, so it reaches till here. I get "I'm in purgatory" on the console.
> > > 
> > > One more thing. Is 2.6.24-rc6 working properly?
> > > 
> > 
> > 2.6.24-rc5 boots, so does 2.6.24-rc5-mm1. 2.6.24-rc6 does not boot, nor
> > does 2.6.24-rc6-mm1. Its a regression.
> 
> Added to the list of reported regressions as:
> http://bugzilla.kernel.org/show_bug.cgi?id=9682
> 

I've no clue what I managed to do wrong last night, probably tried to boot
2.6.24-rc6-mm1 thinking it was 2.6.24-rc6. 2.6.24-rc6 boots, but -mm
does not. Sorry for the noise.

With the help of the outbs I have figured out that it is dying somewhere
in setup_memory(). Will look deeper into it.

-- 
regards,
Dhaval
