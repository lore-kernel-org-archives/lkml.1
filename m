Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbXFULgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbXFULgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 07:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbXFULg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 07:36:27 -0400
Received: from ns2.suse.de ([195.135.220.15]:49170 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754373AbXFULg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 07:36:26 -0400
To: "Robert Richter" <robert.richter@amd.com>
Cc: "Stephane Eranian" <eranian@hpl.hp.com>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/8] 2.6.22-rc3 perfmon2 : Debug messages added
References: <20070620182126.248753000@amd.com>
	<20070620184113.GC5874@erda.amd.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 21 Jun 2007 14:32:10 +0200
In-Reply-To: <20070620184113.GC5874@erda.amd.com>
Message-ID: <p73bqf9qyid.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Robert Richter" <robert.richter@amd.com> writes:

> Debug messages added for better debugging.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> 
> Index: linux-2.6.22-rc3/perfmon/perfmon_file.c
> ===================================================================
> --- linux-2.6.22-rc3.orig/perfmon/perfmon_file.c
> +++ linux-2.6.22-rc3/perfmon/perfmon_file.c
> @@ -192,6 +192,8 @@ static int pfm_mmap(struct file *file, s
>  	unsigned long flags;
>  	int ret;
>  
> +	PFM_DBG("pfm_file_ops");

I don't think that should be in the code when it hits mainline

-Andi
