Return-Path: <linux-kernel-owner+w=401wt.eu-S1945929AbXBVA5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945929AbXBVA5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 19:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945927AbXBVA5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 19:57:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932798AbXBVA5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 19:57:11 -0500
Message-ID: <45DCEA47.5080100@redhat.com>
Date: Wed, 21 Feb 2007 19:56:39 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: netfilter-devel@lists.netfilter.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Soft lockup on shutdown in nf_ct_iterate_cleanup()
References: <45DB9C1F.1080605@redhat.com>
In-Reply-To: <45DB9C1F.1080605@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> I was testing a 2.6.20 kernel and got a soft
> lockup on shutdown:
> 
> _raw_write_lock+0x5a
> nf_ct_iterate_cleanup+0x3e
> kill_l3proto+0x0
> nf_conntrack_l3proto_unregister+0x85
> nf_conntrack_l3proto_ipv4_fini+0x1e
> sys_delete_module+0x18a
> remove_vma+0x45
> do_munmap+0x196
> syscall_call+0x7

Happened three times in a row, trying to remove
netfilter modules.

