Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZAKW33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZAKW33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 17:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZAKW3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 17:29:20 -0500
Received: from relay1.sgi.com ([192.48.179.29]:43119 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751290AbZAKW3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 17:29:20 -0500
Message-ID: <496A72B3.8010105@sgi.com>
Date: Sun, 11 Jan 2009 14:29:07 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, mingo@elte.hu, rusty@rustcorp.com.au
Subject: Re: cpumask change causes sparc build bustage
References: <20090111205008.db0a410e.sfr@canb.auug.org.au>	<20090111.040640.188129980.davem@davemloft.net>	<496A232A.5070801@sgi.com> <20090111.135029.199678338.davem@davemloft.net>
In-Reply-To: <20090111.135029.199678338.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Mike Travis <travis@sgi.com>
> Date: Sun, 11 Jan 2009 08:49:46 -0800
> 
>> Thanks for fixing it.  In actuality though, it should return cpu_mask_all
>> instead of CPU_MASK_ALL_PTR but that's a small nit.
> 
> CPU_MASK_ALL_PTR is defined to &cpu_mask_all, that's why I used it, to
> be consistent with the other macro using CPU_MASK_ALL right above it.

It's not a big deal.  CPU_MASK_ALL_PTR is one of those "bandaids" to
keep current code working until it's all been cleansed of the old
cpumask_t functions.  Rusty's so-called "big hammer" patch.

Thanks,
Mike

