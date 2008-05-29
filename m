Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYE2KsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYE2KsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 06:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYE2KsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 06:48:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36572 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751070AbYE2KsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 06:48:16 -0400
Date: Thu, 29 May 2008 11:34:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Alexander van Heukelum" <heukelum@fastmail.fm>
Cc: "Dave Airlie" <airlied@gmail.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "dri-devel" <dri-devel@lists.sourceforge.net>
Subject: Re: in-kernel DRM tree move around....
Message-ID: <20080529113406.5d8f75c4@core>
In-Reply-To: <1212051908.8215.1255644495@webmail.messagingengine.com>
References: <21d7e9970805281746k71b47ed2i79c06288d2dca022@mail.gmail.com>
	<1212051908.8215.1255644495@webmail.messagingengine.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 11:05:08 +0200
"Alexander van Heukelum" <heukelum@fastmail.fm> wrote:

> On Thu, 29 May 2008 10:46:22 +1000, "Dave Airlie" <airlied@gmail.com>
> said:
> > Hi,
> > 
> > So I've been growing more annoyed with the current layout of the drm
> > tree in the kernel,
> > 
> > a) it lives under char.
> > b) everything in one directory.
> > c) header files in one directory.
> > d) no header files exposed to userspace.
> > 
> > http://git.kernel.org/?p=linux/kernel/git/airlied/drm-2.6.git;a=commitdiff;h=7df9a948d0f849466e3de259cccb49bc54cbad68
> > 
> > is a proposal to create drivers/gpu/drm, (I may move AGP in there as
> > well later). It also creates per-driver subdirs.
> 
> Looks like a lot more suitable place! I just wonder if drivers/video/drm
> would be even more logical?

I think gpu is better - we are seeing various GPU as CPU accelerator
toolkits appearing and assuming the AMD one ends up open source we will
end up with gpu/something that isn't video.

Remember GPU = Grahi^WGeneric Processing Unit ;)

Alan
