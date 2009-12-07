Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbZLGNIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbZLGNIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 08:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757004AbZLGNIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 08:08:15 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58796 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbZLGNIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 08:08:14 -0500
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: miklos@szeredi.hu, luto@mit.edu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20091207130339.620b904b@lxorguk.ukuu.org.uk> (message from Alan
	Cox on Mon, 7 Dec 2009 13:03:39 +0000)
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
	<E1NHWlu-00029N-1t@pomaz-ex.szeredi.hu>
	<20091207122346.6d18a8e1@lxorguk.ukuu.org.uk>
	<E1NHctp-00032C-A1@pomaz-ex.szeredi.hu>
	<E1NHd0J-000345-Kw@pomaz-ex.szeredi.hu> <20091207130339.620b904b@lxorguk.ukuu.org.uk>
Message-Id: <E1NHdJy-00037l-Jb@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 07 Dec 2009 14:08:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009, Alan Cox wrote:
> > In other words, revoking file handles is not enough, we really need to
> > revoke the _inode_.  And if we do that then O_NODE handles are
> > perfectly harmless.
> 
> If you have revoke() you are half way there, you also the need to make
> sure any user cases are updated and well established before you change
> anything under them. It's not good adding a kernel feature which makes an
> old udev version insecure.

It doesn't, see example with hard link two mails up.

Alan, you are just ignoring facts and trying to push revoke(2) which
in fact doesn't have much to do with this issue.  revoke(2) is about
*open devices*, O_NODE doesn't produce an open device.  Don't you
understand that?

Thanks,
Miklos
