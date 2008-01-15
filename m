Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbYAOSMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbYAOSMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 13:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYAOSMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 13:12:31 -0500
Received: from mail.vyatta.com ([216.93.170.194]:56809 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbYAOSMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 13:12:30 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.55
Date: Tue, 15 Jan 2008 10:09:47 -0800
From: Stephen Hemminger <stephen.hemminger@vyatta.com>
To: "Ioan Ionita" <opslynx@gmail.com>
Cc: netdev@vger.kernel.org, jeff@garzik.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: sky2 patch in 2.6.24-rc7-git6 breaks POST - commit
 84cd2dfb04d23a961c5f537baa243fa54d0987ac
Message-ID: <20080115100947.4ec6cda0@deepthought>
In-Reply-To: <df47b87a0801150301w6b970decwdd4bd256aa2ca9ac@mail.gmail.com>
References: <df47b87a0801150301w6b970decwdd4bd256aa2ca9ac@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 13:01:47 +0200
"Ioan Ionita" <opslynx@gmail.com> wrote:

> Hi,
> 
> I have an Asus Commando motherboard, p965 chipset with Marvell
> 88E8056 and 88E8001 gigabit lan onboard. skge and sky2 are compiled
> in.
> When booting linux-2.6.24-rc7-git6, everything seemed fine, but when
> attempting to reboot, the machine would freeze on POST, right before
> detecting AHCI drives.
> In order to get it to POST, a reset or shutdown from the power button
> is not enough, I actually have to cut power to the motherboard using
> the PSU's power switch!
> 
> I first thought that the BIOS or CMOS may have gotten corrupted, but
> eventually I fund that linux was the culprit. After a git bisect, I
> found the bad commit below
> 

Is Wake On Lan enabled in the BIOS?

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>
