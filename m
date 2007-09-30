Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588AbXI3Waw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbXI3Waw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 18:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbXI3Wap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 18:30:45 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:47606 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbXI3Wao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 18:30:44 -0400
To: akpm@linux-foundation.org
CC: elendil@planet.nl, linux-kernel@vger.kernel.org
In-reply-to: <20070930034556.43b9704d.akpm@linux-foundation.org> (message from
	Andrew Morton on Sun, 30 Sep 2007 03:45:56 -0700)
Subject: Re: [2.6.23-rc8-mm2] kernel BUG at mm/slab.c:591! | invalid opcode:
 0000 [#1] SMP
References: <200709282225.21530.elendil@planet.nl>
	<200709300015.36169.elendil@planet.nl> <20070930034556.43b9704d.akpm@linux-foundation.org>
Message-Id: <E1Ic7Ix-0007xT-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 01 Oct 2007 00:30:27 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > +Call Trace:
> > + [<c01d975c>] kobject_cleanup+0x31/0x47
> > + [<c01da45a>] kref_put+0x76/0x84
> > + [<dfe69395>] fuse_sysfs_cleanup+0xa/0x14 [fuse]
> > + [<dfe6a5f2>] fuse_exit+0x19/0x24 [fuse]
> > + [<c01465a0>] sys_delete_module+0x1c0/0x228
> > + [<c0103ece>] sysenter_past_esp+0x6b/0xa1
> > + [<ffffe410>] 0xffffe410
> > + =======================
> > +Code: aa 43 c0 8b 02 25 00 40 02 00 3d 00 40 02 00 75 03 8b 52 0c 8b 02 25 00 40 02 00 3d 00 40 02 00 75 03 8b 52 0c 8b 02 84 c0 78 04 <0f> 0b eb fe 8b 4a 18 64 a1 08 00 40 c0 8b 1c 81 8b 03 3b 43 04 
> > +EIP: [<c016df71>] kfree+0x5e/0x97 SS:ESP 0068:c7205f14
> > 
> 
> I think we have now fixed that - Miklos, do you recall?

Yes, Greg has a fix.  I didn't see it go into -mm yet.

Miklos
