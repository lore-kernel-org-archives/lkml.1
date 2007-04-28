Return-Path: <linux-kernel-owner+w=401wt.eu-S1756188AbXD1NiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbXD1NiJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbXD1NiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:38:09 -0400
Received: from smtp-out001.kontent.com ([81.88.40.215]:40635 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbXD1NiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:38:07 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 15:37:52 +0200
User-Agent: KMail/1.9.1
Cc: "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704272107.28565.oliver@neukum.org> <84144f020704280222s42ff99ddg3eea3cb353c8882e@mail.gmail.com>
In-Reply-To: <84144f020704280222s42ff99ddg3eea3cb353c8882e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704281537.53479.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 28. April 2007 11:22 schrieb Pekka Enberg:
> Hi Oliver,
> 
> Am Freitag, 27. April 2007 12:12 schrieb Pekka J Enberg:
> > > The problem with writing in the kernel is obvious: we need to add new code
> > > to the kernel for compression, encryption, and userspace interaction
> > > (graphical progress bar) that are important for user experience.
> 
> On 4/27/07, Oliver Neukum <oliver@neukum.org> wrote:
> > The kernel can already do compression and encryption.
> 
> Yes, if we all could agree on _which_ compression and encryption

Any of those available in the kernel. Where's the problem?

> algorithm(s) we want to use. It goes beyond that too, where do you
> want to save the image? In the swap device or a regular file? And

A swap device is doubtlessly easier. But isn't the problem of using
a swap file already fixed? The writeout seems the easiest part of
hibernation.

> don't forget about debuggability either. It's faster to do a
> snapshot/resume without shutdown/restart in the middle or just do a
> snapshot, and examine its contents.

Then use a "fake reboot" option and save the image to a ramdisk.
It isn't that hard. You must be able to survive that, as io errors during
write out are possible.

	Regards
		Oliver
