Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbYKML6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbYKML6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 06:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYKML6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 06:58:41 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34244 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbYKML6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 06:58:41 -0500
To: tj@kernel.org
CC: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net, greg@kroah.com,
       linux-kernel@vger.kernel.org
In-reply-to: <491C1588.2060907@kernel.org> (message from Tejun Heo on Thu, 13
	Nov 2008 20:54:48 +0900)
Subject: Re: [PATCHSET] FUSE: extend FUSE to support more operations
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <48F4568B.7000609@kernel.org> <E1KpgL4-00072Q-0C@pomaz-ex.szeredi.hu> <491BC87F.4050108@kernel.org> <E1L0afo-0006gr-UM@pomaz-ex.szeredi.hu> <491C1588.2060907@kernel.org>
Message-Id: <E1L0aqD-0006j0-1K@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 13 Nov 2008 12:58:29 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Tejun Heo wrote:
> Hmm... yeah, allocating handle from kernel should work fine, but I
> wouldn't worry about race here.  We can just use 64 bit and guarantee
> that any handle won't be reused ever.

Right, that sounds perfect.

Thanks,
Miklos
