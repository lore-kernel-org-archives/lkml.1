Return-Path: <linux-kernel-owner+w=401wt.eu-S932859AbXBXN6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859AbXBXN6F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 08:58:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932863AbXBXN6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 08:58:05 -0500
Received: from stinky.trash.net ([213.144.137.162]:52784 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859AbXBXN6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 08:58:04 -0500
Message-ID: <45E04468.7020001@trash.net>
Date: Sat, 24 Feb 2007 14:58:00 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: netfilter-devel@lists.netfilter.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Soft lockup on shutdown in nf_ct_iterate_cleanup()
References: <45DB9C1F.1080605@redhat.com> <45DCEA47.5080100@redhat.com>
In-Reply-To: <45DCEA47.5080100@redhat.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> Chuck Ebbert wrote:
> 
>>I was testing a 2.6.20 kernel and got a soft
>>lockup on shutdown:
>>
>>_raw_write_lock+0x5a
>>nf_ct_iterate_cleanup+0x3e
>>kill_l3proto+0x0
>>nf_conntrack_l3proto_unregister+0x85
>>nf_conntrack_l3proto_ipv4_fini+0x1e
>>sys_delete_module+0x18a
>>remove_vma+0x45
>>do_munmap+0x196
>>syscall_call+0x7
> 
> 
> Happened three times in a row, trying to remove
> netfilter modules.

Does it happen when you unload only nf_conntrack_ipv4, or do
you need to unload other modules previously? Does it really
lock up?

Please also send your config.
