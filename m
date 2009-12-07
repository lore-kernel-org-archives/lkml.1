Return-Path: <linux-kernel-owner+w=401wt.eu-S934863AbZLGMr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934863AbZLGMr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 07:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934104AbZLGMr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 07:47:57 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43274 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933576AbZLGMr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 07:47:56 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: luto@mit.edu, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <E1NHctp-00032C-A1@pomaz-ex.szeredi.hu> (message from Miklos
	Szeredi on Mon, 07 Dec 2009 13:41:09 +0100)
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>
	<20091202191549.1dbffa2e@lxorguk.ukuu.org.uk>
	<E1NFva6-0001AI-0J@pomaz-ex.szeredi.hu>
	<20091202204828.4fa0c108@lxorguk.ukuu.org.uk>
	<E1NG4WJ-00026r-GE@pomaz-ex.szeredi.hu>
	<4B1A7159.3070101@mit.edu>
	<E1NH0Ub-0007oy-43@pomaz-ex.szeredi.hu>
	<20091205202838.3456b6fc@lxorguk.ukuu.org.uk>
	<E1NH1MB-0007v8-Ps@pomaz-ex.szeredi.hu>
	<20091205231304.03a4af61@lxorguk.ukuu.org.uk>
	<E1NHWlu-00029N-1t@pomaz-ex.szeredi.hu> <20091207122346.6d18a8e1@lxorguk.ukuu.org.uk> <E1NHctp-00032C-A1@pomaz-ex.szeredi.hu>
Message-Id: <E1NHd0J-000345-Kw@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 07 Dec 2009 13:47:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Dec 2009, Miklos Szeredi wrote:
>   ln /dev/foo /dev/shm/my_secret_device_link
>   (foo is removed)
>   open("/dev/shm/my_secret_device_link", O_RDWR)
> 
> How is this different than keeping the device open with O_NODE?

In other words, revoking file handles is not enough, we really need to
revoke the _inode_.  And if we do that then O_NODE handles are
perfectly harmless.

Miklos
