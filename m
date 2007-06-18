Return-Path: <linux-kernel-owner+w=401wt.eu-S1762125AbXFRK4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762125AbXFRK4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760452AbXFRK4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:56:08 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:42358 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759723AbXFRK4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:56:05 -0400
To: davem@davemloft.net
CC: tgraf@suug.ch, akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20070618.035144.64026005.davem@davemloft.net> (message from
	David Miller on Mon, 18 Jun 2007 03:51:44 -0700 (PDT))
Subject: Re: [PATCH] fix race in AF_UNIX
References: <20070618103241.GX521@postel.suug.ch>
	<20070618104059.GY521@postel.suug.ch>
	<E1I0ElR-0007Kz-00@dorka.pomaz.szeredi.hu> <20070618.035144.64026005.davem@davemloft.net>
Message-Id: <E1I0EtI-0007Ma-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 12:55:24 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > but it's not as if it's really going to affect performance
> > in real cases.
> 
> Since these circumstances are creatable by any user, we have
> to consider the cases caused by malicious entities.

OK.  But then the whole gc thing is already broken, since a user can
DoS socket creation/destruction.

I'm all for fixing this gc mess that we have now.  But please don't
expect me to be the one who's doing it.

Miklos
