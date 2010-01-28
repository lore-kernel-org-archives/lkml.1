Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466Ab0A1UUx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab0A1UUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:20:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553Ab0A1UUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:20:52 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:19183 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0A1UUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:20:51 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with pci=use_crs)
Date: Thu, 28 Jan 2010 13:20:47 -0700
User-Agent: KMail/1.9.10
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeff Garrett <jeff@jgarrett.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <201001280909.46043.bjorn.helgaas@hp.com> <4B61D554.9000003@kernel.org>
In-Reply-To: <4B61D554.9000003@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001281320.48907.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 January 2010 11:20:04 am Yinghai Lu wrote:
> On 01/28/2010 08:09 AM, Bjorn Helgaas wrote:
> > On Wednesday 27 January 2010 10:53:51 pm Yinghai Lu wrote:
> >> On 01/27/2010 08:26 PM, Bjorn Helgaas wrote:
> >>> On Wed, 2010-01-27 at 15:34 -0800, Yinghai Lu wrote:
> > 
> >>>> 2. how about when apci is disabled?
> >>>
> >>> When ACPI is disabled, I think we just have to accept that we lose some
> >>> functionality.  I don't see the need for alternate ways to accomplish
> >>> everything that ACPI does.  It's becoming less and less useful to
> >>> disable ACPI; I think it's only interesting as a debugging tool, and
> >>> even then it's a sledgehammer.
> >>
> >> some systems when acpi is enabled could have interrupt storm. 
> >> and have to disable acpi.
> > 
> > We should fix that problem rather than just covering it up by
> > disabling ACPI.  Can you provide any details?
> that is not covering problem. acpi just cause too many problems.
> 
> systems using acpi hotplug support, and use acpi aml code to monitor the hotplug status instead of HW
> and after one or two days will have interrupt storm with sci/acpi interrupt aka 9.

If you just want to whine about problems without helping us figure
them out and fix them, I think there's another mailing list for that.

I really don't have time to deal with unsubstantiated rumor-mongering
like this.

Bjorn
