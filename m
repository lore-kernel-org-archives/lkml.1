Return-Path: <linux-kernel-owner+w=401wt.eu-S1763865AbYBOVCC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763865AbYBOVCC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:02:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765132AbYBOVAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:00:50 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52455 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761220AbYBOVAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:00:49 -0500
To: jdike@addtoit.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <20080215204602.GA10036@c2.user-mode-linux.org> (message from
	Jeff Dike on Fri, 15 Feb 2008 15:46:02 -0500)
Subject: Re: 2.6.24-mm1 bugs
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu> <20080215184741.GB8810@c2.user-mode-linux.org> <E1JQ6bM-0005z4-Ac@pomaz-ex.szeredi.hu> <20080215204602.GA10036@c2.user-mode-linux.org>
Message-Id: <E1JQ7fn-00069k-5F@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 15 Feb 2008 22:00:43 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Feb 15, 2008 at 08:52:04PM +0100, Miklos Szeredi wrote:
> > > What does it do?
> > 
> > See below.
> 
> > [    0.420000] Checking host MADV_REMOVE support...<3>MADV_REMOVE failed, err = -38
> 
> Where'd MADV_REMOVE go?  I have it on 2.6.24.

Oh, I always get this message.  Looking closer, this only works if
/tmp is tmpfs.  Which isn't in most cases.

> > [    0.420000] Failed to get registers from stub, errno = 3
> > [    0.420000] wait_stub_done : failed to wait for SIGTRAP, pid = 30073, n = 30073, errno = 0, status = 0x0
> 
> Is utrace in there, by any chance?  When I see crazy stuff like this,
> I think utrace.

Nope.  Must be some other crazy stuff :)

Miklos
