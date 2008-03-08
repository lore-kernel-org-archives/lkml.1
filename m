Return-Path: <linux-kernel-owner+w=401wt.eu-S1761073AbYCHE7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761073AbYCHE7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 23:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYCHE7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 23:59:31 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60956 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbYCHE7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 23:59:31 -0500
Date: Sat, 8 Mar 2008 14:03:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [6/13] Core maskable allocator
Message-Id: <20080308140334.15987554.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080307090716.9D3E91B419C@basil.firstfloor.org>
References: <200803071007.493903088@firstfloor.org>
	<20080307090716.9D3E91B419C@basil.firstfloor.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Mar 2008 10:07:16 +0100 (CET)
Andi Kleen <andi@firstfloor.org> wrote:

> +static int __init setup_maskzone(char *s)
> +{
> +	do {
> +		if (isdigit(*s)) {
> +			mask_zone_size = memparse(s, &s);
> +		} else if (!strncmp(s, "force", 5)) {
> +			force_mask = 1;
> +			s += 5;
> +		} else
> +			return -EINVAL;
> +		if (*s == ',')
> +			++s;
> +	} while (*s);
> +	return 0;
> +}
> +early_param("maskzone", setup_maskzone);

please confirm mask_zone_size is aligned to MAX_ORDER.

Thanks,
-Kame

