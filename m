Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbYAPKMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbYAPKMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 05:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbYAPKMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 05:12:06 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42431 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbYAPKMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 05:12:05 -0500
To: hidave.darkstar@gmail.com
CC: R.E.Wolff@bitwizard.nl, linux-kernel@vger.kernel.org,
       salikhmetov@gmail.com
In-reply-to: <a8e1da0801160203s234f7005k3e95aa8b007c0f70@mail.gmail.com>
	(hidave.darkstar@gmail.com)
Subject: Re: mtime updates for mmapped files.
References: <20080116094640.GA2071@bitwizard.nl> <a8e1da0801160203s234f7005k3e95aa8b007c0f70@mail.gmail.com>
Message-Id: <E1JF5FW-0003Kr-DL@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 16 Jan 2008 11:11:58 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > Hi,
> >
> > I  wrote a small app yesterday that updates a file by mmapping the
> > file (RW), changing the thing around, and then exiting.
> >
> > This did not trigger a change in the mtime of the file. Thus rsync
> > didn't pick up that the file had changed.
> >
> > I understand that tracking every change to a RW mmapped file is
> > costly, and thus unfeasable, but shouldn't then the close cause a
> > mtime update?
> >
> > The server where this happened is running 2.6.21, so my apologies if
> > this has already been corrected.
> 
> This is an old bug, don't know if it was fixed or not. Please see
> http://lkml.org/lkml/2006/5/17/138

It's not fixed yet, but Anton Salikhmetov is currently working on it:

http://lkml.org/lkml/2008/1/15/202

Miklos
