Return-Path: <linux-kernel-owner+w=401wt.eu-S1759213AbXK1Pfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbXK1Pfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbXK1Pfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:35:31 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44800 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751719AbXK1Pf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:35:29 -0500
To: jdike@addtoit.com
CC: mingo@elte.hu, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <20071128150637.GA5518@c2.user-mode-linux.org> (message from Jeff
	Dike on Wed, 28 Nov 2007 10:06:37 -0500)
Subject: Re: -rt doesn't compile for UML
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128150637.GA5518@c2.user-mode-linux.org>
Message-Id: <E1IxOwS-000752-HF@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 Nov 2007 16:35:12 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > When writing a big file to a ubd disk, everything in uml slows down to
> > a crawl, even though CPU usage is minimal.
> 
> What exactly is your test case?

Something like:

  dd if=/host/tmp/bigfile of=/tmp/bigfile bs=1048576 count=100

and run 'top' or 'watch something' in another terminal, which
sometimes completely stops updating during the write.

> I have some patches which theoretically should help I/O performance
> which I've been sitting on because I can't find a case where they
> help.

It's not I/O performance I'm worried about, but scheduling latencies.
CPU use inside and outside the UML is minimal, so I can't see where
this slowdown comes from.

Miklos
