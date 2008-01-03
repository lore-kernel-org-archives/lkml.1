Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbYACW3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbYACW3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 17:29:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbYACW3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 17:29:16 -0500
Received: from waste.org ([66.93.16.53]:42474 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967AbYACW3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 17:29:15 -0500
Subject: Re: [patch 1/2] move WARN_ON() out of line
From: Matt Mackall <mpm@selenic.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       olof@lixom.net
In-Reply-To: <477D52ED.7000403@linux.intel.com>
References: <477D52ED.7000403@linux.intel.com>
Content-Type: text/plain
Date: Thu, 03 Jan 2008 16:27:55 -0600
Message-Id: <1199399275.7815.1.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-03 at 22:26 +0100, Arjan van de Ven wrote:
> Subject: move WARN_ON() out of line
> From: Arjan van de Ven <arjan@linux.intel.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Olof Johansson <olof@lixom.net>
> CC: Matt Meckall <mpm@selenic.com>
> 
> A quick grep shows that there are currently 1145 instances of WARN_ON
> in the kernel. Currently, WARN_ON is pretty much entirely inlined,
> which makes it hard to enhance it without growing the size of the kernel
> (and getting Andrew rightfully unhappy).
> 
> This patch build on top of Olof's patch that introduces __WARN,
> and places the slowpath out of line. It also uses Ingo's suggestion
> to not use __FUNCTION__ but to use kallsyms to do the lookup;
> this saves a ton of extra space since gcc doesn't need to store the function
> string twice now:
>
> 3936367  833603  624736 5394706  525112 vmlinux.before
> 3917508  833603  624736 5375847  520767 vmlinux-slowpath

Nice!

Acked-by: Matt Mackall <mpm@selenic.com>

-- 
Mathematics is the supreme nostalgia of our time.

