Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbYKVFS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbYKVFS3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 00:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbYKVFSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 00:18:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835AbYKVFSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 00:18:21 -0500
Date: Fri, 21 Nov 2008 21:17:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, greg@kroah.com
Subject: Re: [PATCH 5/5] CUSE: implement CUSE - Character device in
 Userspace
Message-Id: <20081121211756.a211d3a8.akpm@linux-foundation.org>
In-Reply-To: <49279324.7010605@kernel.org>
References: <1227190983-5820-1-git-send-email-tj@kernel.org>
	<1227190983-5820-6-git-send-email-tj@kernel.org>
	<E1L3bA9-0000Dx-Vb@pomaz-ex.szeredi.hu>
	<49279324.7010605@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Nov 2008 14:05:40 +0900 Tejun Heo <tj@kernel.org> wrote:

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

No, I don't believe that miscdev minors are handled by lanana.

otoh, we've added only one new miscdev minor since 2005.  All the new
code is using dynamic allocation.  Readers of your changelog and code
comments will be wondering why you didn't do so ;)


