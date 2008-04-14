Return-Path: <linux-kernel-owner+w=401wt.eu-S1758283AbYDNM1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbYDNM1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbYDNM1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:27:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60518 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbYDNM1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:27:38 -0400
To: jamie@shareable.org
CC: miklos@szeredi.hu, dwmw2@infradead.org, hch@infradead.org,
       akpm@linux-foundation.org, me@bobcopeland.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20080414115540.GA5802@shareable.org> (message from Jamie Lokier
	on Mon, 14 Apr 2008 12:55:40 +0100)
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
References: <20080413033344.GA27494@hash.localnet> <20080412205544.5e12a7d4.akpm@linux-foundation.org> <20080413080130.GA9622@infradead.org> <20080413012001.8d7967f4.akpm@linux-foundation.org> <20080413082815.GA20108@infradead.org> <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu> <1208121358.2700.4.camel@shinybook.infradead.org> <E1JlJ4U-0004xa-Sf@pomaz-ex.szeredi.hu> <20080414094215.GD2076@shareable.org> <E1JlLRt-0005JD-QR@pomaz-ex.szeredi.hu> <20080414115540.GA5802@shareable.org>
Message-Id: <E1JlNly-0005bt-2v@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 14 Apr 2008 14:26:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Yes, that's quite annoying as FUSE doesn't work with my architecture,
> > > so I can't use the only good NTFS driver.... grr! :-)
> > 
> > I'm not quite getting this joke :)
> 
> It's not really a joke.  It really is a problem: I'm supposed to
> provide NTFS support for a project, but the kernel I'm using doesn't
> work with FUSE (too old for the FUSE version needed by ntfs-3g),

How old?  The out of tree fuse module (hoping to get rid of it soon)
works down to 2.6.9.  Beyond that it does probably require a fair
amount of porting work.

Miklos
