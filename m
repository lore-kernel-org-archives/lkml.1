Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab0BKMes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 07:34:48 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59122 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab0BKMer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:34:47 -0500
To: Tejun Heo <tj@kernel.org>
CC: miklos@szeredi.hu, mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
In-reply-to: <4B73EE68.4070004@kernel.org> (message from Tejun Heo on Thu, 11
	Feb 2010 20:47:52 +0900)
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org> <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu> <4B7344A4.1030607@kernel.org> <E1NfVOi-0002l9-5l@pomaz-ex.szeredi.hu> <4B73EE68.4070004@kernel.org>
Message-Id: <E1NfYFm-00034C-Pd@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 11 Feb 2010 13:34:42 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010, Tejun Heo wrote:
> It's not like it's something completely foreign.  It's a limitation
> which can also be found in shared memory and the server side mmap
> doesn't really have much to do with it.  It's also necessary to avoid
> aliasing issues among clients.

What aliasing issues among clients?  That's a job for the arch
dependent part of mmap.  And as you said, there's not a lot the driver
can do (except play with ->vm_pgoff) to influence the address
selection.

And playing with ->vm_pgoff is *not* a valid thing to do for the
client, at least not on "normal" mmaps.

Thanks,
Miklos
