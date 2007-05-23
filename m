Return-Path: <linux-kernel-owner+w=401wt.eu-S934102AbXEWQCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102AbXEWQCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758151AbXEWQB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:01:56 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755861AbXEWQBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:01:55 -0400
Date: Wed, 23 May 2007 09:01:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>
Subject: Re: 2.6.22-rc2-mm1
Message-Id: <20070523090146.43ce5d15.akpm@linux-foundation.org>
In-Reply-To: <46542D05.8070206@googlemail.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<46542D05.8070206@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 14:01:09 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:

> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc2/2.6.22-rc2-mm1/
> >   
> 
> I get this on boot :
> 
> [ 0.333581] BUG: at include/linux/slub_def.h:83 kmalloc_index()
> [ 0.333587] [<c0104eb7>] show_trace_log_lvl+0x1a/0x2f
> [ 0.333601] [<c0105a76>] show_trace+0x12/0x14
> [ 0.333606] [<c0105a8e>] dump_stack+0x16/0x18
> [ 0.333611] [<c0170d1c>] get_slab+0x48/0x138
> [ 0.333621] [<c0170e8d>] __kmalloc+0x11/0x66
> [ 0.333626] [<c0283c66>] get_modalias+0x5e/0xee
> [ 0.333635] [<c0283d3f>] dmi_dev_uevent+0x2a/0x3f
> [ 0.333641] [<c0241a7b>] dev_uevent+0x1ad/0x1da
> [ 0.333650] [<c01d11fe>] kobject_uevent_env+0x200/0x3ff
> [ 0.333658] [<c01d1407>] kobject_uevent+0xa/0xf
> [ 0.333664] [<c02416fc>] device_add+0x283/0x440
> [ 0.333669] [<c02418cb>] device_register+0x12/0x15
> [ 0.333675] [<c0424558>] dmi_id_init+0x256/0x26c
> [ 0.333684] [<c0409516>] kernel_init+0x156/0x2c1
> [ 0.333692] [<c0104b33>] kernel_thread_helper+0x7/0x10
> [ 0.333698] =======================
> 
> 
> http://crazy.dev.frugalware.org/2.6.22-rc2-mm1/config-2.6.22-rc2-mm1
> http://crazy.dev.frugalware.org/2.6.22-rc2-mm1/dmesg
> 

yup, thanks.  David Airlie has said he'll look into this soon.  It is
a harmless warning.
