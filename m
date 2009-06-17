Return-Path: <linux-kernel-owner+w=401wt.eu-S1764551AbZFQIey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764551AbZFQIey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbZFQIel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:34:41 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:52504 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752772AbZFQIej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:34:39 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Russell King <rmk@arm.linux.org.uk>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: arm build failures
References: <20090617162612.703adfd9.sfr@canb.auug.org.au>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 17 Jun 2009 09:34:31 +0100
In-Reply-To: <20090617162612.703adfd9.sfr@canb.auug.org.au> (Stephen Rothwell's message of "Wed\, 17 Jun 2009 16\:26\:12 +1000")
Message-ID: <tnx3a9ztg14.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jun 2009 08:34:33.0072 (UTC) FILETIME=[706C6F00:01C9EF26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Over the past few days, I have started getting some arm configs (at least
> iop13xx_defconfig and integrator_defconfig, but some others) failing to
> build getting this error:
>
>   SYSMAP  System.map
>   SYSMAP  .tmp_System.map
> Inconsistent kallsyms data
> Try setting CONFIG_KALLSYMS_EXTRA_PASS
>
> Is this something you have seen?  Could it be my toolchain (I am
> currently using gcc 4.4.0 and have not changed it recently)?

I reported an error with kallsysms on ARM this Monday leading to
inconsistent data:

http://lkml.org/lkml/2009/6/15/233

Could it be related?

-- 
Catalin
