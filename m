Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbXB1UbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbXB1UbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 15:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbXB1UbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 15:31:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbXB1UbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 15:31:16 -0500
Message-ID: <45E5E683.7000509@redhat.com>
Date: Wed, 28 Feb 2007 15:30:59 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: netfilter-devel@lists.netfilter.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Soft lockup on shutdown in nf_ct_iterate_cleanup()
References: <45DB9C1F.1080605@redhat.com> <45DCEA47.5080100@redhat.com> <45E04468.7020001@trash.net> <45E06546.504@redhat.com> <45E1C7E0.9070102@trash.net> <45E31572.4040108@redhat.com> <45E31EB5.6000809@trash.net> <45E34F74.8050807@redhat.com> <45E5C549.2030009@trash.net>
In-Reply-To: <45E5C549.2030009@trash.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> Thanks, the previous approach doesn't seem to work properly without
> unpleasant event cache hacks. This patch takes a simpler approach
> and keeps the unconfirmed list iteration, but makes sure to make
> forward progress.
> 
> 
> 
> ------------------------------------------------------------------------
> 
> [NETFILTER]: conntrack: fix {nf,ip}_ct_iterate_cleanup endless loops
> 
> Fix {nf,ip}_ct_iterate_cleanup unconfirmed list handling:
> 

Works great: survived three reboots without lockup or warning messages.
And it's a nice simple patch, too...

