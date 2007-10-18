Return-Path: <linux-kernel-owner+w=401wt.eu-S1763447AbXJRDQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763447AbXJRDQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 23:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbXJRDQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 23:16:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50641 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbXJRDQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 23:16:14 -0400
Date: Thu, 18 Oct 2007 12:17:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: menage@google.com (Paul Menage)
Cc: akpm@linux-foundation.org, pj@sgi.com, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Simplify /proc/cgroups
Message-Id: <20071018121745.35c740bd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071018025636.ADCDE3D6261@localhost>
References: <20071018025636.ADCDE3D6261@localhost>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 19:56:36 -0700 (PDT)
menage@google.com (Paul Menage) wrote:

> +		seq_printf(m, "%s\t%d\t%d\n",
> +			   ss->name, ss->root->subsys_bits,
> +			   ss->root->number_of_cgroups);
>  	}
Because subsys_bits is unsigned long, then %lu or %lx is better.

Thanks,
-Kame

