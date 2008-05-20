Return-Path: <linux-kernel-owner+w=401wt.eu-S1765509AbYETMUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765509AbYETMUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbYETMUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:20:23 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:41765 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbYETMUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:20:23 -0400
Message-ID: <54484.145.64.134.222.1211286021.squirrel@www.hardeman.nu>
In-Reply-To: <12bd24d7-17d4-4df8-abca-42740ec309fe@x35g2000hsb.googlegroups.com>
References: <avxTs-570-21@gated-at.bofh.it>
    <12bd24d7-17d4-4df8-abca-42740ec309fe@x35g2000hsb.googlegroups.com>
Date: Tue, 20 May 2008 14:20:21 +0200 (CEST)
Subject: Re: Loading DSDT from initrd, can it be done from grub instead?
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: "Alan Jenkins" <aj504@cs.york.ac.uk>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 13:58, Alan Jenkins wrote:
> David Härdeman wrote:
>> In commit 9a9e0d685553af76cb6ae2af93cca4913e7fcd47 the
>> ACPI_CUSTOM_DSDT_INITRD option was removed.
>>
>> I was wondering if it'd be feasible to hack grub to load a custom DSDT
>> instead (since grub can read filesystems) and then pass a pointer to a
>> memory location containing the DSDT to the kernel?
>
> Um, why?  What stops you from reverting the offending commit?

Because doing it from grub (if possible) would allow custom DSDT's to be
loaded without patching the kernel (e.g. allows distro kernels to be used)
and without introducing code that opens files from kernel space and mucks
with both the VFS and ACPI in ugly ways?

> Without further info, I'd assume the feature was removed on policy
> grounds.  I.e. it's not nice to be effectively patching the BIOS
> yourself, and vendors have fixed most of their BIOS's / linux is
> slightly more tolerant to broken ones. I don't know whats wrong with
> reading files from the initrd.

If you do not understand the issue at hand, why comment?

-- 
David Härdeman

