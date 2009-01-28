Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbZA1GIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbZA1GIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 01:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZA1GIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 01:08:43 -0500
Received: from gate.crashing.org ([63.228.1.57]:40100 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbZA1GIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 01:08:42 -0500
Cc: jeff@garzik.org, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, rjw@sisk.pl
Message-Id: <FA2D66A9-FA13-49B5-8335-60DA75F79D19@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1233118922-15350-2-git-send-email-galak@kernel.crashing.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH] ata_piix: Fix build breakage
Date: Wed, 28 Jan 2009 00:08:30 -0600
References: <1233118922-15350-1-git-send-email-galak@kernel.crashing.org> <1233118922-15350-2-git-send-email-galak@kernel.crashing.org>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 27, 2009, at 11:02 PM, Kumar Gala wrote:

> The following commit introduces:
>
> commit 5f451fe1ab5d73b987051f0d23c85216c552e163
> Author: Rafael J. Wysocki <rjw@sisk.pl>
> Date:   Mon Jan 19 20:59:22 2009 +0100
>
>    SATA PIIX: Blacklist system that spins off disks during ACPI  
> power off
>
> the following build errors on non-x86 systems:
>
> drivers/ata/ata_piix.c: In function 'piix_broken_system_poweroff':
> drivers/ata/ata_piix.c:1405: error: implicit declaration of function  
> 'dmi_first_match'
> drivers/ata/ata_piix.c:1405: warning: initialization makes pointer  
> from integer without a cast
>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> drivers/ata/ata_piix.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)

it was pointed out that fixing include/linux/dmi.h was the better way  
to fix this.  I've posted a patch for fixing dmi.h that supersedes  
this patch.

- k
