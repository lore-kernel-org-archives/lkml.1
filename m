Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbXDKKtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbXDKKtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbXDKKtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:49:15 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:34868 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbXDKKtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:49:14 -0400
To: raven@themaw.net
CC: hpa@zytor.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
In-reply-to: <1176195125.3476.47.camel@raven.themaw.net> (message from Ian
	Kent on Tue, 10 Apr 2007 16:52:05 +0800)
Subject: Re: [patch 0/8] unprivileged mount syscall
References: <20070404183012.429274832@szeredi.hu>
	 <20070406160238.f3178189.akpm@linux-foundation.org>
	 <4616D4D4.6020405@zytor.com> <1176195125.3476.47.camel@raven.themaw.net>
Message-Id: <E1HbaNO-0005AV-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Apr 2007 12:48:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > >>
> > >> - users can use bind mounts without having to pre-configure them in
> > >>   /etc/fstab
> > >>
> > 
> > This is by far the biggest concern I see.  I think the security 
> > implication of allowing anyone to do bind mounts are poorly understood.
> 
> And especially so since there is no way for a filesystem module to veto
> such requests.

The filesystem can't veto initial mounts based on destination either.
I don't think it's up to the filesystem to police bind/move mounts in
any way.

Miklos
