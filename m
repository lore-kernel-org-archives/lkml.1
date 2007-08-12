Return-Path: <linux-kernel-owner+w=401wt.eu-S933117AbXHLUXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117AbXHLUXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 16:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbXHLUXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 16:23:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60765 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379AbXHLUXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 16:23:22 -0400
Date: Sun, 12 Aug 2007 21:23:20 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Mark Cannon <random.bits@rogers.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Use of directories to hold root?
Message-ID: <20070812202320.GE21089@ftp.linux.org.uk>
References: <200708101724.26724.random.bits@rogers.com> <46BCFE01.2040703@zytor.com> <Pine.LNX.4.64.0708111753510.3101@fbirervta.pbzchgretzou.qr> <200708121539.48332.random.bits@rogers.com> <Pine.LNX.4.64.0708122147440.28963@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708122147440.28963@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 09:49:02PM +0200, Jan Engelhardt wrote:
> 
> On Aug 12 2007 15:39, Mark Cannon wrote:
> >> >> No, but you can use pivot_root.
> >> >
> >> >Or better yet, use an initramfs with MS_MOVE; same as you would with the
> >> >"normal" use of initramfs.
> >
> >I am not sure I understand initramfs with MS_MOVE concept. I will look into
> >it. Any pointers for documentation? 
> 
> pivot_root is atomic afaict, for `mount --move` (which I think Al meant 
> which MS_MOVE - or some C program using mount(2) of your own), you'd 
> need multiple calls to mount.

Move itself is done by a single syscall anyway...
