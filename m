Return-Path: <linux-kernel-owner+w=401wt.eu-S1760631AbXEROfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760631AbXEROfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbXEROfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:35:31 -0400
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:36472 "EHLO
	ribosome.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbXEROfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:35:30 -0400
Date: Fri, 18 May 2007 16:35:29 +0200
From: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, ext3-users@redhat.com
Subject: Re: 2.6.22-rc1 killed my ext3 filesystem cleanly unmounted
Message-ID: <20070518143529.GB14611@ribosome.natur.cuni.cz>
References: <20070518090604.GA10841@ribosome.natur.cuni.cz> <9a8748490705180720u3baf9785l910581a2a76a6eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490705180720u3baf9785l910581a2a76a6eb@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2007 at 04:20:39PM +0200, Jesper Juhl wrote:
>  On 18/05/07, Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz> wrote:
> > Hi,
> >   I just tried the 2.6.22-r1 candidate to test whether some bug I have
> > hit in the past still exists. I did use 2.6.20.6 so far. So, I have
> > cleanly rebooted to use the new kernel, after the machine came up I
> > tried to mess with the bug, and had to reboot again to play with kernel
> > commandline parameters. Unfortunately, on the next reboot fsck was
> > schedules on my filesystem after 38 clean mounts. :( And the problem
> > started. The fsck found some unused inodes, but probably did not know
> > where do they belong to, but it deleted them automagically. Finally, the
> > fsck died because it cannot fine some '..' entry.
> >
> 
>  How do you know that the corruption was caused by 2.6.21-rc1 ?
>  Isn't it possible that the corruption was created by an earlier
>  kernel, but only detected when a forced fsck was run - which just
>  happened to be while you were running 2.6.21-rc1 ...
> 
>  My point is that, as far as I can see, there's nothing tying
>  2.6.21-rc1 specifically to this corruption... or?

You might be right, but I thought maybe more probably is the cause in kernel
as that is what I have changed recently. ;) Or maybe someone can at leats say
"No, no changes to be considered between 2.6.20.6 and 2.6.22-rc1.". ;)

Martin
