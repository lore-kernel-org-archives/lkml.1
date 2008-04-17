Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbYDQIR4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbYDQIR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:17:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754297AbYDQIRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:17:34 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59587 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbYDQIRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:17:32 -0400
To: jamie@shareable.org
CC: szaka@ntfs-3g.org, miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20080417065059.GA21524@shareable.org> (message from Jamie Lokier
	on Thu, 17 Apr 2008 07:50:59 +0100)
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
References: <1208121358.2700.4.camel@shinybook.infradead.org> <E1JlJ4U-0004xa-Sf@pomaz-ex.szeredi.hu> <20080414094215.GD2076@shareable.org> <E1JlLRt-0005JD-QR@pomaz-ex.szeredi.hu> <20080414115540.GA5802@shareable.org> <E1JlNly-0005bt-2v@pomaz-ex.szeredi.hu> <20080414223556.GA21340@shareable.org> <E1JljQD-0008Ae-5H@pomaz-ex.szeredi.hu> <20080415152313.GB8513@shareable.org> <Pine.LNX.4.61.0804170357290.4657@dhcppc2> <20080417065059.GA21524@shareable.org>
Message-Id: <E1JmPJ3-0003k7-PJ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 17 Apr 2008 10:17:21 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (Btw, The NTFS-3g release notes, on it's decision to replace the FUSE
> userspace libs (which is what makes it work with 2.4 kernels too),
> suggest there may be serious problems in the standard FUSE libs,
> especially on small devices.

There were compatibility problems with uClibc, but those have now been
addressed in the standard fuse libs as well.

I actually think fuse-lite is a good thing (as long as someone is
maintining it): it allows dynamically changing projects like ntfs-3g
to distribute and link their own version of libfuse, which contains
the latest features they need.  Not having to wait for these features
to slowly make it into distributions can be a big advantage.

At the same time fuse-lite doesn't need to carry all the source and
binary compatibility cruft that the standard fuse lib needs, so
statically linking it has a relatively small overhead.

Miklos
