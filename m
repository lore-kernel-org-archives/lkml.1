Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbYKPALT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbYKPALT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 19:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYKPALJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 19:11:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbYKPALG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 19:11:06 -0500
Date: Sun, 16 Nov 2008 01:11:04 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Bernhard Walle <bwalle@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 2/2] Add dev.mem.restricted sysctl
Message-ID: <20081116011104.10114522@kopernikus.site>
In-Reply-To: <1226793823-32360-3-git-send-email-bwalle@suse.de>
References: <1226793823-32360-1-git-send-email-bwalle@suse.de>
	<1226793823-32360-3-git-send-email-bwalle@suse.de>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bernhard Walle [2008-11-16 01:03]:
>
> +
> +static const struct trans_ctl_table trans_mem_table[] = {
> +	{ DEV_MEM_RESTRICTED,	"restricted" },
> +	{}
> +};

Noticed that we either need to put everything into CONFIG_STRICT_DEVMEM
or nothing. But I want to head opinions if the concept can be accepted
before I repost.



Regards,
Bernhard
