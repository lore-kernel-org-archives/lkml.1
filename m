Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbYKVIlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbYKVIlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 03:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751811AbYKVIk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 03:40:58 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33739 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYKVIk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 03:40:58 -0500
To: tj@kernel.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       greg@kroah.com
In-reply-to: <49279324.7010605@kernel.org> (message from Tejun Heo on Sat, 22
	Nov 2008 14:05:40 +0900)
Subject: Re: [PATCH 5/5] CUSE: implement CUSE - Character device in Userspace
References: <1227190983-5820-1-git-send-email-tj@kernel.org> <1227190983-5820-6-git-send-email-tj@kernel.org> <E1L3bA9-0000Dx-Vb@pomaz-ex.szeredi.hu> <49279324.7010605@kernel.org>
Message-Id: <E1L3o2v-0001Nz-Oi@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 22 Nov 2008 09:40:53 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2008, Tejun Heo wrote:
> Miklos Szeredi wrote:
> > On Thu, 20 Nov 2008, Tejun Heo wrote:
> >> diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
> >> index 0be9245..d4dcca8 100644
> >> --- a/include/linux/miscdevice.h
> >> +++ b/include/linux/miscdevice.h
> >> @@ -28,6 +28,7 @@
> >>  #define MPT_MINOR		220
> >>  #define	HPET_MINOR		228
> >>  #define FUSE_MINOR		229
> >> +#define CUSE_MINOR		230
> > 
> > This doesn't work: device numbers have to be allocated by LANANA.
> 
> My last attempt at LANANA for extended devt didn't get me anywhere and
> I'm not sure LANANA is handling miscdevice minors at all.

Back then I did get the fuse device registered in LANANA database
(http://www.lanana.org/docs/device-list/devices-2.6+.txt)

>   If you go
> through the tree, there are quite a few duplicate allocations including
> FUSE_MINOR.  At any rate, we can definitely try LANANA.

Ugh, I suppose that's my fault for not putting the definition in
miscdevice.h (though apparently the duplicates didn't do so either).

Thanks,
Miklos
