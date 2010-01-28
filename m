Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055Ab0A1VRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab0A1VRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 16:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754606Ab0A1VQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 16:16:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:46360 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab0A1VQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 16:16:58 -0500
Message-ID: <4B61FE48.3090500@kernel.org>
Date: Thu, 28 Jan 2010 13:14:48 -0800
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
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <201001280909.46043.bjorn.helgaas@hp.com> <4B61D554.9000003@kernel.org> <201001281331.06218.bjorn.helgaas@hp.com>
In-Reply-To: <201001281331.06218.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2010 12:31 PM, Bjorn Helgaas wrote:
> On Thursday 28 January 2010 11:20:04 am Yinghai Lu wrote:
>> On 01/28/2010 08:09 AM, Bjorn Helgaas wrote:
>>> On Wednesday 27 January 2010 10:53:51 pm Yinghai Lu wrote:
>>> We should fix that problem rather than just covering it up by
>>> disabling ACPI.  Can you provide any details?
>> that is not covering problem. acpi just cause too many problems.
>>
>> systems using acpi hotplug support, and use acpi aml code to monitor the hotplug status instead of HW
>> and after one or two days will have interrupt storm with sci/acpi interrupt aka 9.
>> ...
>> check many systems have broken acpi?
>> some system acpi code even clear pci bar when just enable acpi at the first point.
> 
> Sorry, let me try to be more constructive.  You mention some things
> above that might be issues with Linux.  I am eager to help fix them.

should be have problem on several parties.
good hw design should let fgpa to monitor that change, instead of have bunch ACPI AML code
on host cpu to do that.

> 
> However, to make progress, I need information, not just rumors.  Can
> you point me to bug reports?  Bugzillas?  Ways to reproduce the
> problems?
I asked our HW engineer to update fpga to handle the problem already.

YH
