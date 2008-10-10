Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbYJJIKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbYJJIKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYJJIJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:09:57 -0400
Received: from mail.ukfsn.org ([77.75.108.10]:51338 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbYJJIJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:09:53 -0400
Message-ID: <48EF0DB7.90909@dgreaves.com>
Date: Fri, 10 Oct 2008 09:09:27 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: SMART to USB/sata dock in 2.6.27-rc5 doesn't work : hardware
 limitation
References: <48EE7E0A.8040701@dgreaves.com>
In-Reply-To: <48EE7E0A.8040701@dgreaves.com>
X-Enigmail-Version: 0.95.0
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Greaves wrote:
> Hi
> 
> I just bought a usb/sata adapter like this:
>   http://www.thinkgeek.com/computing/drives/a7ea/?cpg=ab
> lsusb -v is below
> 
> Works OK as a hot-plug SATA disk so I can check what's on that old disk in the
> corner; but smartctl doesn't work so I can't see if it has any errors, run
> selftests etc.

So, for the record since I had no luck on google, I had an off-list reply that
pointed here: Smartmontools for FireWire, USB, and SATA disks/systems
  http://smartmontools.sourceforge.net/faq.html#testinghelp

It's an odd URL target - it's actually about the fact that the usb/sata bridges
built into the docks don't fully support the scsi command set in their hardware;
so my SMART doesn't work and has no chance of being fixed by software. Future
chipsets (and some current cypress ones) may have various developments in
hardware to fix this.

HTH someone else.

David


-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
