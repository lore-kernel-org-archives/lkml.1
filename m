Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbZA1GOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbZA1GOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 01:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbZA1GOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 01:14:11 -0500
Received: from gate.crashing.org ([63.228.1.57]:55088 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbZA1GOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 01:14:10 -0500
Cc: jeff@garzik.org, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, rjw@sisk.pl
Message-Id: <5B9826B6-792F-4C66-A4C1-E002B0DD60B1@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1233118922-15350-3-git-send-email-galak@kernel.crashing.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH] sata_sil: Fix build breakage
Date: Wed, 28 Jan 2009 00:08:56 -0600
References: <1233118922-15350-1-git-send-email-galak@kernel.crashing.org> <1233118922-15350-2-git-send-email-galak@kernel.crashing.org> <1233118922-15350-3-git-send-email-galak@kernel.crashing.org>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 27, 2009, at 11:02 PM, Kumar Gala wrote:

> The following commit introduces:
>
> commit e57db7bde7bff95ae812736ca00c73bd5271455b
> Author: Rafael J. Wysocki <rjw@sisk.pl>
> Date:   Mon Jan 19 20:58:29 2009 +0100
>
>    SATA Sil: Blacklist system that spins off disks during ACPI power  
> off
>
> the following build errors on non-x86 systems:
>
> drivers/ata/sata_sil.c: In function 'sil_broken_system_poweroff':
> drivers/ata/sata_sil.c:713: error: implicit declaration of function  
> 'dmi_first_match'
> drivers/ata/sata_sil.c:713: warning: initialization makes pointer  
> from integer without a cast
>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> drivers/ata/sata_sil.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)


it was pointed out that fixing include/linux/dmi.h was the better way  
to fix this.  I've posted a patch for fixing dmi.h that supersedes  
this patch.

- k
