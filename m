Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbYKULF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbYKULF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 06:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYKULFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 06:05:14 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60431 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbYKULFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 06:05:13 -0500
To: tj@kernel.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net
In-reply-to: <49268876.7080303@kernel.org> (message from Tejun Heo on Fri, 21
	Nov 2008 19:07:50 +0900)
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations, take
 #2
References: <1227190298-4585-1-git-send-email-tj@kernel.org> <E1L3G3Q-0006SJ-Uc@pomaz-ex.szeredi.hu> <49268876.7080303@kernel.org>
Message-Id: <E1L3Tp0-0007dc-3S@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Nov 2008 12:05:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008, Tejun Heo wrote:
> > I removed ->unrestricted_ioctl() and associated code because it really
> > doesn't make any sense: the high level lib won't be used for CUSE
> > stuff, otherwise unrestrited ioctls are not allowed (and the interface
> > is rather horrible anyway).
> 
> Well, CUSE highlevel interface piggy backs on FUSE so it requires
> unrestricted_ioctl() there for it and ossp does use it.

I thought it uses the lowlevel interface.  Why doesn't it do that?

For CUSE there's really no point in going through high level
interface, since there's just one file involved, so the path name
generation (the main feature of the highlevel lib) doesn't make any
sense.

Thanks,
Miklos
