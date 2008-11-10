Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbYKJXaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbYKJXaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 18:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbYKJXaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 18:30:11 -0500
Received: from eazy.amigager.de ([213.239.192.238]:41851 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbYKJXaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 18:30:09 -0500
Date: Tue, 11 Nov 2008 00:30:15 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] Suspend regression in stable kernel 2.6.27.4 on Mac
	mini Core Duo
Message-ID: <20081110233014.GA5163@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org, stable@kernel.org
References: <20081109202830.GA7206@x61> <20081109203441.GA4871@kroah.com> <200811092151.57620.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811092151.57620.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2008 at 21:51:57 +0100, Rafael J. Wysocki wrote:
> On Sunday, 9 of November 2008, Greg KH wrote:
> > On Sun, Nov 09, 2008 at 09:28:30PM +0100, Tino Keitel wrote:
> > > Hi,
> > > 
> > > my Mac mini Core Duo doesn't wake up from suspend to RAM anymore with
> > > 2.6.27.4. It works with 2.6.27.3. I enabled pm_trace, but dmesg | grep
> > > "hash matches" didn't show anything after resume. I tried 2.6.27.5,
> > > which also failed to resume.
> > > 
> > > The system is i386, the hardware is basically Intel based: Core Duo
> > > T2300 CPU, Intel graphics i945, ICH7, Marvell GbE (sky2), a SATA hard
> > > disk, PATA DVD drive, a Firewire hard disk, and a lot of USB devices.
> > > 
> > > Does that ring any bells? Any hints what commit I should try to revert?
> > 
> > Can you run 'git bisect' on the patches in 2.6.27.4 to see which one
> > broke your box?
> 
> I would start from these commits:
> 
> 3b987ac961486373f91191b14291b331fa546072
> "ACPI suspend: Always use the 32-bit waking vector"
> 
> 66036f5862883fcc9f7ff8550685a5a3de1a57e4
> "ACPI Suspend: Enable ACPI during resume if SCI_EN is not set"

Thanks Rafael, 2.6.27.5 with 66036f5862883fcc9f7ff8550685a5a3de1a57e4
reverted resumes fine.

Regards,
Tino
