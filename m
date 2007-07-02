Return-Path: <linux-kernel-owner+w=401wt.eu-S1760374AbXGBOkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760374AbXGBOkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbXGBOkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:40:42 -0400
Received: from fiberbit.xs4all.nl ([213.84.224.214]:58008 "EHLO
	fiberbit.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699AbXGBOkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:40:42 -0400
Date: Mon, 2 Jul 2007 16:29:26 +0200
From: Marco Roeland <marco.roeland@xs4all.nl>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: why does git perpetually complain about
	include/asm-blackfin/macros.h?
Message-ID: <20070702142926.GB10400@fiberbit.xs4all.nl>
References: <Pine.LNX.4.64.0707020800010.1972@localhost.localdomain> <4688EF9B.8020405@garzik.org> <9a8748490707020658t5e6542ag6edb435dbc4499ab@mail.gmail.com> <4689073D.1020802@garzik.org> <81b0412b0707020722q25e8eb41t456e7316fe4a7b40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <81b0412b0707020722q25e8eb41t456e7316fe4a7b40@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday July 2nd 2007 at 16:22 Alex Riesen wrote:

> Do some of your branches miss the commit by which it was removed?
> (It was removed in df30b1171714bbf0e55ffe02138be4b8447e4235)
> Than it will reappear every time you switch to a branch which still has
> the file.

The problem is that this commit didn't delete the file, but truncated it
to zero size. How it got to be like that is another matter. Within the
kernel zero sized files are not supposed to be there, by widely accepted
practice. So lots of tools assume they should delete them!
-- 
Marco Roeland
