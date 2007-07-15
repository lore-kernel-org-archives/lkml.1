Return-Path: <linux-kernel-owner+w=401wt.eu-S1760518AbXGOX2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760518AbXGOX2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 19:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbXGOX2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 19:28:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:28465 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbXGOX2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 19:28:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VEaeSLUAMsDfmy/yeS6BuKoFpiyIA3naG3PuKRv7bqXoaSjlWXb+ikt5khAfDd9TkzRC8DBpcPdpahzCz4gpeQPvEWpP0mzJ3dVVLKWETyB+tvF9UsRNxJ8W9g8Ql5jUeNqN09l/eLYbe3uEURSvDcIO8fFrnLIbcy8bHPt6zqE=
Message-ID: <a781481a0707151628p1971e1c4ma00b1d34d848e39e@mail.gmail.com>
Date: Mon, 16 Jul 2007 04:58:36 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: Patches for REALLY TINY 386 kernels
Cc: "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jonathan Campbell" <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200707160113.56110.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469A8AED.7070207@nerdgrounds.com>
	 <200707160912.55701.nigel@nigel.suspend2.net>
	 <a781481a0707151614k57165061l464943233e9b32e8@mail.gmail.com>
	 <200707160113.56110.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ the off-topic zillion-ways-to-do-same-thing-in-*nix sub-thread ]

On 7/16/07, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 16 July 2007, Satyam Sharma wrote:
> > > Yeah. I was going for the general principle :)
> >
> > Even simpler to add --exclude-from=.gitignore to diff
> >
> Or build in a separate object directory, using the O=$my_objdir
> Kbuild option. That has a number of addition advantages, e.g.
> you can easily clean your object files using 'rm -rf $my_objdir'
> and if you grep -r the source, you don't find your search string
> in generated files.

Or just "cp -al" to create multiple trees at (almost) no disk cost
that won't interfere with each other in any way, and makes the
development process / generating patchsets trifle easier as well ...

Or best of all, just start using git if you can ...

... ok, back to work now.

Satyam
