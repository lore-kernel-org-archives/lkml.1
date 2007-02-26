Return-Path: <linux-kernel-owner+w=401wt.eu-S1030524AbXBZVWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030524AbXBZVWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030525AbXBZVWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:22:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030524AbXBZVWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:22:09 -0500
Message-ID: <45E34F74.8050807@redhat.com>
Date: Mon, 26 Feb 2007 16:21:56 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: netfilter-devel@lists.netfilter.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Soft lockup on shutdown in nf_ct_iterate_cleanup()
References: <45DB9C1F.1080605@redhat.com> <45DCEA47.5080100@redhat.com> <45E04468.7020001@trash.net> <45E06546.504@redhat.com> <45E1C7E0.9070102@trash.net> <45E31572.4040108@redhat.com> <45E31EB5.6000809@trash.net>
In-Reply-To: <45E31EB5.6000809@trash.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick McHardy wrote:
> This patch is against current stable-2.6.20, it applies
> cleanly to 2.6.20 as well.
> 

Everything works OK, but I get:

BUG: warning: (!list_empty(&unconfirmed)) at
net/netfilter/nf_conntrack_core.c:1068/nf_ct_cleanup()

<> nf_ct_cleanup+0x66/0x122 [nf_conntrack]
<> kill_l4proto+0x0 [nf_conntrack]
<> nf_conntrack_l4proto_unregister+0x7d/0x82 [nf_conntrack]
<> nf_conntrack_l3proto_ipv4_fini+0x3c/0x46 [nf_conntrack_ipv4]
<> sys_delete_module+0x18a/0x1b1
...

netconsole doesn't seem to work as a module for me, so hand
copied from screen.
