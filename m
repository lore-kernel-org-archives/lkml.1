Return-Path: <linux-kernel-owner+w=401wt.eu-S1759975AbZFKBxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975AbZFKBxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 21:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbZFKBxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 21:53:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:55990 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720AbZFKBxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 21:53:30 -0400
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>
Message-Id: <87E7BC96-041F-4244-8370-B8EE64EEDA7F@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Wolfgang Denk <wd@denx.de>
In-Reply-To: <1242155174-2513-1-git-send-email-wd@denx.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH] [PowerPC] MPC8272ADS: fix device tree for 8 MB flash size
Date: Wed, 10 Jun 2009 20:51:19 -0500
References: <1242155174-2513-1-git-send-email-wd@denx.de>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 12, 2009, at 2:06 PM, Wolfgang Denk wrote:

> The current device tree for the MPC8272ADS assumes a mapping of 32 MB
> of NOR flash at 0xFE00.0000, while there are actually only 8 MB on
> the boards, mapped at 0xFF80.0000. When booting an uImage with such a
> device tree, the kernel crashes because 0xFE00.0000 is not mapped.
>
> Also introduce aliases for serial[01] and ethernet[01].
>
> Signed-off-by: Wolfgang Denk <wd@denx.de>
> Cc: Scott Wood <scottwood@freescale.com>
> cc: Kumar Gala <galak@kernel.crashing.org>
> ---
> I am not really sure what the typical flash size on MPC8272ADS boards
> is. The board I used for testing is marked as "Prototype", so it may
> not be the release configuration. On the other hand, the manual also
> says 8 MB, Vitaly Borduk confirms 8 MB on his board, too, and Scott
> Wood eventually tested only with cuImage which fixes up the localbus
> mappings, thus eventually concealing the issue.
>
> I'm posting this as reference in case the 8 MB should turn out to be
> correct. -- wd
>
> arch/powerpc/boot/dts/mpc8272ads.dts |   19 +++++++++++++------
> 1 files changed, 13 insertions(+), 6 deletions(-)


applied to next.

- k
