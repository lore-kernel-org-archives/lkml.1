Return-Path: <linux-kernel-owner+w=401wt.eu-S1752192AbXCFE6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbXCFE6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 23:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbXCFE6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 23:58:11 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50999 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbXCFE6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 23:58:10 -0500
Date: Mon, 5 Mar 2007 20:57:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 004 of 4] knfsd: Provide sunrpc pool_mode module option
Message-Id: <20070305205757.2d5db738.akpm@linux-foundation.org>
In-Reply-To: <1070306021520.26937@suse.de>
References: <20070306131103.26638.patches@notabene>
	<1070306021520.26937@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007 13:15:20 +1100 NeilBrown <neilb@suse.de> wrote:

> Provide a module param "pool_mode" for sunrpc.ko which allows a
> sysadmin to choose the mode for mapping NFS thread service pools
> to CPUs.  Values are:
> 
> auto	    choose a mapping mode heuristically
> global	    (default, same as the pre-2.6.19 code) a single global pool
> percpu	    one pool per CPU
> pernode	    one pool per NUMA node
> 
> Note that since 2.6.19 the hardcoded behaviour has been "auto",
> this patch makes the default "global".
> 
> The pool mode can be changed after boot/modprobe using /sys, if the
> NFS and lockd services have been shut down.  A useful side effect of
> this change is to fix a small memory leak when unloading the module.

Mutter.  Is this really suitable and needed for 2.6.21 at this stage in
its life?
