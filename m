Return-Path: <linux-kernel-owner+w=401wt.eu-S932305AbXBUBLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbXBUBLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932310AbXBUBLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:11:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305AbXBUBLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:11:24 -0500
Message-ID: <45DB9C1F.1080605@redhat.com>
Date: Tue, 20 Feb 2007 20:10:55 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: netfilter-devel@lists.netfilter.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Soft lockup on shutdown in nf_ct_iterate_cleanup()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was testing a 2.6.20 kernel and got a soft
lockup on shutdown:

_raw_write_lock+0x5a
nf_ct_iterate_cleanup+0x3e
kill_l3proto+0x0
nf_conntrack_l3proto_unregister+0x85
nf_conntrack_l3proto_ipv4_fini+0x1e
sys_delete_module+0x18a
remove_vma+0x45
do_munmap+0x196
syscall_call+0x7


