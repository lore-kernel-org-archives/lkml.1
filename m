Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918Ab0A1QKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab0A1QKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 11:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463Ab0A1QKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 11:10:43 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:41864 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab0A1QKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 11:10:42 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works =?iso-8859-1?q?with=09pci=3Duse=5Fcrs?=)
Date: Thu, 28 Jan 2010 09:09:44 -0700
User-Agent: KMail/1.9.10
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeff Garrett <jeff@jgarrett.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <1264652762.24020.5.camel@dc7800.home> <4B61266F.1060600@kernel.org>
In-Reply-To: <4B61266F.1060600@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001280909.46043.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 January 2010 10:53:51 pm Yinghai Lu wrote:
> On 01/27/2010 08:26 PM, Bjorn Helgaas wrote:
> > On Wed, 2010-01-27 at 15:34 -0800, Yinghai Lu wrote:

> >> 2. how about when apci is disabled?
> > 
> > When ACPI is disabled, I think we just have to accept that we lose some
> > functionality.  I don't see the need for alternate ways to accomplish
> > everything that ACPI does.  It's becoming less and less useful to
> > disable ACPI; I think it's only interesting as a debugging tool, and
> > even then it's a sledgehammer.
> 
> some systems when acpi is enabled could have interrupt storm. 
> and have to disable acpi.

We should fix that problem rather than just covering it up by
disabling ACPI.  Can you provide any details?

I think it's crazy to add code to work around Problem B that only
occurs because we disabled ACPI to work around Problem A.  We should
just fix Problem A instead.

Bjorn
