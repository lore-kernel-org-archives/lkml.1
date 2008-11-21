Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbYKUSzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbYKUSzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbYKUSze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:55:34 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33665 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbYKUSze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:55:34 -0500
To: tj@kernel.org
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, greg@kroah.com,
       tj@kernel.org
In-reply-to: <1227190983-5820-6-git-send-email-tj@kernel.org> (message from
	Tejun Heo on Thu, 20 Nov 2008 23:23:03 +0900)
Subject: Re: [PATCH 5/5] CUSE: implement CUSE - Character device in Userspace
References: <1227190983-5820-1-git-send-email-tj@kernel.org> <1227190983-5820-6-git-send-email-tj@kernel.org>
Message-Id: <E1L3bA9-0000Dx-Vb@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Nov 2008 19:55:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2008, Tejun Heo wrote:
> diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
> index 0be9245..d4dcca8 100644
> --- a/include/linux/miscdevice.h
> +++ b/include/linux/miscdevice.h
> @@ -28,6 +28,7 @@
>  #define MPT_MINOR		220
>  #define	HPET_MINOR		228
>  #define FUSE_MINOR		229
> +#define CUSE_MINOR		230

This doesn't work: device numbers have to be allocated by LANANA.

But maybe we can get away with a dynamic number, now that everyone
uses udev?

Miklos
