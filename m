Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbXKNP0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbXKNP0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 10:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbXKNP0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 10:26:32 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59640 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754586AbXKNP0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 10:26:32 -0500
To: jdike@addtoit.com
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-reply-to: <20071114142247.GA5848@c2.user-mode-linux.org> (message from Jeff
	Dike on Wed, 14 Nov 2007 09:22:47 -0500)
Subject: Re: uml doesn't work on 2.6.24-rc2
References: <E1Is5FL-00078H-00@dorka.pomaz.szeredi.hu> <20071114011002.GA11477@c2.user-mode-linux.org> <E1IsFbA-0007y2-00@dorka.pomaz.szeredi.hu> <20071114142247.GA5848@c2.user-mode-linux.org>
Message-Id: <E1IsK83-0008CJ-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 14 Nov 2007 16:26:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Note, this is 32bit UML on 64bit host, to complicate matters.  So I
> > think it's not PTRACE_ARCH_PRCTL, but PTRACE_SET_THREAD_AREA.
> 
> Oh, that changes things.  In this case, I believe this problem is fixed
> by fd181c72a3c202a3986bcee7551c0838265aec2a.

This one fixed the EINVAL messages, and now UML boots, but consumes
100% CPU constantly.

> You'll also need f86f9e6d66027bdcdc9b40c06d431ee53ea0d509 for a
> separate problem.

I can't find this in -linus.  Which tree is it?

> > Maybe this is a fallout from the x86 architecture merge?
> 
> No, the problems had been there from before the merge - years, in the
> case of the second one.

Never seen anything like this until 2.6.24.  Strange...

Miklos
