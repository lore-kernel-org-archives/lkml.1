Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYACVj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYACVj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 16:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYACVju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 16:39:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49359 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbYACVjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 16:39:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: kexec refuses to boot latest -mm
Date: Thu, 3 Jan 2008 22:42:00 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Vivek Goyal <vgoyal@redhat.com>, hbabu@us.ibm.com,
       lkml <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org
References: <20071228124532.GB32643@linux.vnet.ibm.com> <20071231150843.GB27060@redhat.com> <20080103195201.GC6392@linux.vnet.ibm.com>
In-Reply-To: <20080103195201.GC6392@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801032242.01425.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 3 of January 2008, Dhaval Giani wrote:
> On Mon, Dec 31, 2007 at 10:08:43AM -0500, Vivek Goyal wrote:
> > On Sat, Dec 29, 2007 at 11:11:13AM +0530, Dhaval Giani wrote:
> > > On Fri, Dec 28, 2007 at 09:27:39AM -0500, Vivek Goyal wrote:
> > > > On Fri, Dec 28, 2007 at 06:15:32PM +0530, Dhaval Giani wrote:
> > > > > Hi Vivek,
> > > > > 
> > > > > I can't seem to get the latest -mm (2.6.24-rc6-mm1) to boot with
> > > > > kexec. It just gets stuck at "Starting new kernel".
> > > > > 
> > > > > It does boot normally when booted as the first kernel.
> > > > > 
> > > > > Any hints debugging? (x86 architecture)
> > > > 
> > > > I generally try few things.
> > > > 
> > > > - Specify earlyprintk= parameter for second kernel and see if control
> > > >   is reaching to second kernel.
> > > > 
> > > > - Otherwise specify --console-serial parameter on "kexec -l" commandline
> > > >   and it should display a message "I am in purgatory" on serial console.
> > > >   This will just mean that control has reached at least till purgatory.
> > > > 
> > > 
> > > Ok, so it reaches till here. I get "I'm in purgatory" on the console.
> > 
> > One more thing. Is 2.6.24-rc6 working properly?
> > 
> 
> 2.6.24-rc5 boots, so does 2.6.24-rc5-mm1. 2.6.24-rc6 does not boot, nor
> does 2.6.24-rc6-mm1. Its a regression.

Added to the list of reported regressions as:
http://bugzilla.kernel.org/show_bug.cgi?id=9682

Thanks,
Rafael
