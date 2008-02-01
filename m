Return-Path: <linux-kernel-owner+w=401wt.eu-S1760438AbYBARTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760438AbYBARTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbYBART1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:19:27 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:41695 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbYBART0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:19:26 -0500
Message-ID: <47A35498.4000305@garzik.org>
Date: Fri, 01 Feb 2008 12:19:20 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Shane Huang <Shane.Huang@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] PCI: modify SB700 SATA MSI quirk
References: <B90463BC30D2E446BA423D888DC85E501BF9C7@sshaexmb1.amd.com> <479985C0.9020100@gmail.com>
In-Reply-To: <479985C0.9020100@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> From: Shane Huang <shane.huang@amd.com>
> 
> SB700 SATA MSI bug will be fixed in SB700 revision A21 at hardware
> level, but the SB700 revision older than A21 will also be found in the
> market.  This patch modify the original quirk commit
> bc38b411fe696fad32b261f492cb4afbf1835256 instead of withdrawing it.
> The patch also removes quirk to 0x4395 because 0x4395 is SB800 device
> ID.
> 
> Signed-off-by: Shane Huang <shane.huang@amd.com>
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> Okay, here's reformatted in-line version.  Shane, please invest some
> time into setting up email environment.  Sending patches via email is
> an important part of the linux kernel development process and if
> you're gonna submit patches, you're just gonna have to do it.
> 
>  drivers/pci/quirks.c |   29 ++++++++++++++++++++++-------
>  1 file changed, 22 insertions(+), 7 deletions(-)

FWIW, I'm happy with whatever this thread results in...   it sounds like 
Tejun and Shane are iterating towards a satisfactory final result.

Just let me know if I need to merge something, since I'm assuming that 
GregKH will push this through the PCI tree.


