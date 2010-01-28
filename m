Return-Path: <linux-kernel-owner+w=401wt.eu-S932283Ab0A1SXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab0A1SXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 13:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386Ab0A1SXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 13:23:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:59056 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab0A1SXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 13:23:11 -0500
Message-ID: <4B61D554.9000003@kernel.org>
Date: Thu, 28 Jan 2010 10:20:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeff Garrett <jeff@jgarrett.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with pci=use_crs)
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <1264652762.24020.5.camel@dc7800.home> <4B61266F.1060600@kernel.org> <201001280909.46043.bjorn.helgaas@hp.com>
In-Reply-To: <201001280909.46043.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2010 08:09 AM, Bjorn Helgaas wrote:
> On Wednesday 27 January 2010 10:53:51 pm Yinghai Lu wrote:
>> On 01/27/2010 08:26 PM, Bjorn Helgaas wrote:
>>> On Wed, 2010-01-27 at 15:34 -0800, Yinghai Lu wrote:
> 
>>>> 2. how about when apci is disabled?
>>>
>>> When ACPI is disabled, I think we just have to accept that we lose some
>>> functionality.  I don't see the need for alternate ways to accomplish
>>> everything that ACPI does.  It's becoming less and less useful to
>>> disable ACPI; I think it's only interesting as a debugging tool, and
>>> even then it's a sledgehammer.
>>
>> some systems when acpi is enabled could have interrupt storm. 
>> and have to disable acpi.
> 
> We should fix that problem rather than just covering it up by
> disabling ACPI.  Can you provide any details?
that is not covering problem. acpi just cause too many problems.

systems using acpi hotplug support, and use acpi aml code to monitor the hotplug status instead of HW
and after one or two days will have interrupt storm with sci/acpi interrupt aka 9.
> 
> I think it's crazy to add code to work around Problem B that only
> occurs because we disabled ACPI to work around Problem A.  We should
> just fix Problem A instead.

that is not point. fix BIOS or HW or OS?

check many systems have broken acpi?
some system acpi code even clear pci bar when just enable acpi at the first point.

YH
