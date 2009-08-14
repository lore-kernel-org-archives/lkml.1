Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZHNRhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZHNRhX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 13:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756691AbZHNRhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 13:37:22 -0400
Received: from outbound-mail-127.bluehost.com ([67.222.38.27]:51530 "HELO
	outbound-mail-127.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756328AbZHNRhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 13:37:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=OiPa6UQjaumQN7/W636yQYXtdYQ7rSA7eR8iNILDYeGWmcUf1TYSBdmSG6EYkfGHF3+OD+DGg/vCIehJrQ3+hyk+Oeg6HQizMmsRpf+RZ3c7LjHbPdnmWt9/14QxEABB;
Date: Fri, 14 Aug 2009 10:37:19 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       linux-pci@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [RFC] PCI: Runtime power management
Message-ID: <20090814103719.79e99d91@jbarnes-g45>
In-Reply-To: <20090813002925.GA2532@srcf.ucam.org>
References: <200908081625.57333.rjw@sisk.pl>
	<200908092313.05541.rjw@sisk.pl>
	<20090813002925.GA2532@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009 01:29:25 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> I got a fixed BIOS from Dell and have been able to get this working
> now. It seems entirely happy with USB, but I'd like some sanity
> checks on whether I'm doing this correctly. There's certainly a
> couple of quirks related to setting the ACPI GPE type that would need
> a little bit of work in the ACPI layer, and it breaks ACPI-mediated
> PCI hotplug though that's easy enough to fix by just calling into the
> hotplug code from the core notifier.
> 
> This patch builds on top of Rafael's work on systemwide runtime power
> management. It supports suspending and resuming PCI devices at
> runtime, enabling platform wakeup events that allow the devices to
> automatically resume when appropriate. It currently requires platform
> support, but PCIe setups could be supported natively once native PCIe
> PME code has been added to the kernel.

PCI bits look pretty good to me, though Rafael should take a look too.
Card readers and firewire could benefit from similar treatment, maybe
that would get us to .5W territory on some machines.

-- 
Jesse Barnes, Intel Open Source Technology Center
