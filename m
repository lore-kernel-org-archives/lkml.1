Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbYIAQhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbYIAQhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYIAQgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:36:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:51187 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbYIAQgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:36:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=oIf/bNWOkl+3kd2CVOn/DBX42YWo+mwPxML2G88kz+bE7F/h+C+4Fd7jst28HZCF6g
         /rAbSxxgm7zxM58MhdA/5KWl4pltJBBYUEmFz5+HM7zdPEEjQbtm9KS2cjJxSXR01G14
         L7ncmfJdbxwwMaSiofs3GhRDm6js/hzncpSUs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@redhat.com>
Subject: Re: linux-next: Tree for August 29
Date: Mon, 1 Sep 2008 18:33:02 +0200
User-Agent: KMail/1.9.9
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <1488691311.5043621220261605940.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1488691311.5043621220261605940.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809011833.02570.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2008, Alan Cox wrote:
> > Unfortunately it cannot be simply reverted so it seems
> > like WTF part will need some work after all... ;)
> 
> Tis already fixed ...

Still happens with next-20080901, also upon closer look it is not
just an innocent trace dump as /proc/sys/kernel/pty/ dir and its
content are gone.

Care to send a link to a patch and the patch itself to Stephen so
we can have it fixed also in linux-next?

sysctl table check failed: /kernel/pty/nr .1.62.2 No data
Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc5-next-20080901 #197
 [<c012f45c>] set_fail+0x30/0x39
 [<c012f88e>] sysctl_check_table+0x429/0x467
 [<c012f8a5>] sysctl_check_table+0x440/0x467
 [<c012f8a5>] sysctl_check_table+0x440/0x467
 [<c0121b17>] __register_sysctl_paths+0xab/0x23c
 [<c02ff281>] mutex_lock+0x15/0x23
 [<c0160b49>] exact_lock+0x0/0xd
 [<c0121cc2>] register_sysctl_paths+0x1a/0x1c
 [<c03edd7c>] pty_init+0x215/0x293
 [<c0101122>] _stext+0x3a/0x12a
 [<c03edb67>] pty_init+0x0/0x293
 [<c0117300>] __enqueue_entity+0xcc/0xe2
 [<c0128baf>] __create_workqueue_key+0x14d/0x162
 [<c03d94ba>] kernel_init+0xec/0x150
 [<c03d93ce>] kernel_init+0x0/0x150
 [<c0103a47>] kernel_thread_helper+0x7/0x10
 =======================
