Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0BJSAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 13:00:32 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43282 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab0BJSAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 13:00:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH 8/9] PCI / ACPI / PM: Platform support for PCI PME wake-up (rev. 7)
Date: Wed, 10 Feb 2010 19:00:54 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <201001101431.38630.rjw@sisk.pl> <201002100212.29904.rjw@sisk.pl> <20100210174826.GB10093@us.ibm.com>
In-Reply-To: <20100210174826.GB10093@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002101900.54478.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 February 2010, Gary Hade wrote:
> On Wed, Feb 10, 2010 at 02:12:29AM +0100, Rafael J. Wysocki wrote:
> > On Wednesday 10 February 2010, Rafael J. Wysocki wrote:
> > > On Wednesday 10 February 2010, Gary Hade wrote:
> > > > On Tue, Feb 09, 2010 at 12:58:39PM -0800, Gary Hade wrote:
> > > ...
> > > > > OK.  I already confirmed that the problem reproduces with your
> > > > > patches applied.  I am now in the process of trying vanilla
> > > > > 2.6.33-rc7.  If hot-add works with 2.6.33-rc7 I will give
> > > > > your patch a try.
> > > > 
> > > > The hot-add worked fine with an unpatched 2.6.33-rc7.
> > > 
> > > Good.
> > > 
> > > > The new patch when added to the 2.6.33-rc7 tree that
> > > > included the original patchset unfortunately did not
> > > > correct the problem.
> > > 
> > > Bad.
> > > 
> > > Well, fortunately I have another one, but I haven't tested it myself yet except
> > > for checking that it builds.  Hopefully it won't break things more.
> > > 
> > > The patch below applies on top of 2.6.33-rc7 with my PCI runtime PM patchset
> > > applied.  Please test it and let me know the results.
> > 
> > Sorry, I sent a wrong version of the patch by mistake, it doesn't even build.
> > The correct one is appended.
> 
> No problem.  I received this message before doing anything with
> the previous one.
> 
> Sorry, both hot-add and hot-remove behaviors appear unchanged
> with this patch.

Hmm, that's kind of strange.  I'm getting suspicious.

> I would like to dig into the code and help with the debugging
> but I am swamped with other things right now.  However, feel 
> free to continue using me for testing if you have other ideas
> you want me to try.

Thanks, of course I have some ideas. :-)

First, please try to test 2.6.33-rc7 with patches [1/9] - [7/9] applied
(ie. without the $subject patch and [9/9]).  Let's make sure we're debugging
the right patch.

Rafael
