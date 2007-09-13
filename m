Return-Path: <linux-kernel-owner+w=401wt.eu-S1765171AbXIMFxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765171AbXIMFxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 01:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbXIMFxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 01:53:42 -0400
Received: from vsmtp02.dti.ne.jp ([202.216.231.137]:37367 "EHLO
	vsmtp02.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbXIMFxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 01:53:41 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC] Union Mount: Readdir approaches 
To: Al Boldi <a1426z@gawab.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, bharata@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, Jan Blunck <jblunck@suse.de>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
In-Reply-To: <200709130832.09330.a1426z@gawab.com>
References: <20070907054618.GD1692@in.ibm.com> <Pine.LNX.4.64.0709122024500.22467@fbirervta.pbzchgretzou.qr> <E1IVeEx-0000rJ-1R@jroun> <200709130832.09330.a1426z@gawab.com>
Date: Thu, 13 Sep 2007 14:52:35 +0900
Message-Id: <E1IVhcx-0000qV-V0@jroun>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Al Boldi:
> It turns out that the problem was this in dentry.c:
	:::
> Commenting the #if block makes it compile now.
> 
> Works great too.  Even performance wise.  Needs more testing though.

Thank you for your report and forwarding your original message.
And I am glad that it is working for you.

It seems that '#if ... #endif' in an 'unlikly' macro argument is bad
coding. I don't know why my compiler and other users compiler didn't
produce an error.
Anyway, I'll fix such code.


> You really need to post a cleaned up version for review and possible 
> inclusion into mainline.  It definitely looks solid.

I'll try in the future.


Thanks
Junjiro Okajima
