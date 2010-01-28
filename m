Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300Ab0A1UbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab0A1UbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098Ab0A1UbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:31:12 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:7290 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab0A1UbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:31:10 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with pci=use_crs)
Date: Thu, 28 Jan 2010 13:31:05 -0700
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
Message-Id: <201001281331.06218.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 January 2010 11:20:04 am Yinghai Lu wrote:
> On 01/28/2010 08:09 AM, Bjorn Helgaas wrote:
> > On Wednesday 27 January 2010 10:53:51 pm Yinghai Lu wrote:
> > We should fix that problem rather than just covering it up by
> > disabling ACPI.  Can you provide any details?
> that is not covering problem. acpi just cause too many problems.
> 
> systems using acpi hotplug support, and use acpi aml code to monitor the hotplug status instead of HW
> and after one or two days will have interrupt storm with sci/acpi interrupt aka 9.
> ...
> check many systems have broken acpi?
> some system acpi code even clear pci bar when just enable acpi at the first point.

Sorry, let me try to be more constructive.  You mention some things
above that might be issues with Linux.  I am eager to help fix them.

However, to make progress, I need information, not just rumors.  Can
you point me to bug reports?  Bugzillas?  Ways to reproduce the
problems?

Bjorn
