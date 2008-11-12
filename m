Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbYKLXVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbYKLXVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYKLXUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:20:01 -0500
Received: from kroah.org ([198.145.64.141]:42330 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754074AbYKLXUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:20:00 -0500
Date: Wed, 12 Nov 2008 14:48:05 -0800
From: Greg KH <greg@kroah.com>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Ross Cohen <rcohen@snurgle.org>
Subject: Re: [PATCH] staging: fix go7007 build failure
Message-ID: <20081112224805.GE27479@kroah.com>
References: <4917D726.7070406@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4917D726.7070406@cn.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 02:39:34PM +0800, Wang Chen wrote:
> >From 25a87bb72b5d391c3f01a623c12ce22bc5bb2467 Mon Sep 17 00:00:00 2001
> From: Wang Chen <wangchen@cn.fujitsu.com>
> Date: Mon, 10 Nov 2008 14:24:08 +0800
> Subject: [PATCH] staging: fix go7007 build failure
> 
> Comes from commit: df20d69ec968b33526461457c219ad4ba8ba8ac8
> "Staging: go7007 v4l fixes".
> 
> CC [M]  drivers/staging/go7007/go7007-v4l2.o
> drivers/staging/go7007/go7007-v4l2.c:1457: error: 'VID_TYPE_CAPTURE' undeclared here (not in a function)
> make[3]: *** [drivers/staging/go7007/go7007-v4l2.o] Error 1
> make[2]: *** [drivers/staging/go7007] Error 2
> make[1]: *** [drivers/staging] Error 2
> make: *** [drivers] Error 2

Now fixed by moving everything to the v4l2 api :)

thanks,

greg k-h
