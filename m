Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbYEISbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbYEISbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 14:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYEISbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 14:31:04 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52326 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYEISbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 14:31:03 -0400
To: bfields@fieldses.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       trond.myklebust@fys.uio.no
In-reply-to: <20080509181106.GF1907@fieldses.org> (bfields@fieldses.org)
Subject: Re: [patch 1/9] lockd: dont return EAGAIN from blocking lock
	request
References: <20080509124107.645600519@szeredi.hu> <20080509124127.179314495@szeredi.hu> <20080509181106.GF1907@fieldses.org>
Message-Id: <E1JuXMo-0002W1-9L@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 09 May 2008 20:30:50 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > EAGAIN does not make sense as a return value from a blocking lock
> 
> But nlm_stat_to_errno() is called in the non-blocking case too, right?
> What am I missing?

Yes, you're right, I messed that up and didn't even test properly.

Will fix.

Thanks,
Miklos
