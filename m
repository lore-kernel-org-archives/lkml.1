Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbXD2Ork@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbXD2Ork (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 10:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbXD2Orj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 10:47:39 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49486 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364AbXD2Ori (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 10:47:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: kexec@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [Fastboot] restoring x86 BIOS state before reboot
References: <20070406154628.GG12005@jukie.net>
	<m1zm4rd676.fsf@ebiederm.dsl.xmission.com>
	<20070429094135.GA10948@suse.de>
Date: Sun, 29 Apr 2007 08:46:59 -0600
In-Reply-To: <20070429094135.GA10948@suse.de> (Bernhard Walle's message of
	"Sun, 29 Apr 2007 11:41:35 +0200")
Message-ID: <m1ejm38cgs.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bernhard Walle <bwalle@suse.de> writes:

> * Eric W. Biederman <ebiederm@xmission.com> [2007-04-29 08:51]:
>> 
>> It may also be worth investigating if it is possible to bypass
>> the part of windows that uses BIOS calls.  I really don't have
>> a clue how a modern windows systems boots.
>
> I think ReactOS has a bootlader that can also boot Windows, or at
> least they are close to booting the Windows kernel. That bootloader
> could be then used for booting Windows without BIOS calls.
>
> I also heard that the 100-$-Laptop should now be able to use Windows.
> As it's using LinuxBIOS, this could also be interesting. However,
> maybe Microsoft simply modifies a special Windows for this, or they
> integrate a ClosedSource part in that LinuxBIOS, I don't know ... :-(

I know it isn't a ClosedSource part in LinuxBIOS.

In any particular case you can work through the details, and
make it work.

The hard part is making the general case work.

Eric
