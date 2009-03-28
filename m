Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbZC1Lxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbZC1Lxu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 07:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbZC1Lxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 07:53:40 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:47936 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753914AbZC1Lxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 07:53:39 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-01.arcor-online.net DE4B9332A61
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Linux 2.6.29
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Sat, 28 Mar 2009 12:53:34 +0100
References: <ckcE8-845-9@gated-at.bofh.it> <ckdgW-uA-1@gated-at.bofh.it> <ckdK0-1om-1@gated-at.bofh.it> <ckiqk-uZ-13@gated-at.bofh.it> <cklHL-5IW-23@gated-at.bofh.it> <ckm0Q-6o4-3@gated-at.bofh.it> <ckmaG-6AC-5@gated-at.bofh.it> <ckmWO-7Ro-5@gated-at.bofh.it> <ckn6L-84h-19@gated-at.bofh.it> <cknzG-ff-7@gated-at.bofh.it> <cknJk-IB-9@gated-at.bofh.it> <ckoFm-2eg-3@gated-at.bofh.it> <ckoYP-2DC-13@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LnX6V-0001aA-AU@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Fri, 27 Mar 2009, Linus Torvalds wrote:

>> Yes, some editors (vi, emacs) do it, but even there it's configurable.
> 
> .. and looking at history, it's even pretty modern. From the vim logs:
> 
> Patch 6.2.499
> Problem:   When writing a file and halting the system, the file might be lost
> when using a journalling file system.
> Solution:  Use fsync() to flush the file data to disk after writing a file.
> (Radim Kolar)
> Files:     src/fileio.c
> 
> so it looks (assuming those patch numbers mean what they would seem to
> mean) that 'fsync()' in vim is from after 6.2 was released. Some time in
> 2004.

Besides that, it's a fix specific for /journaled/ filesystems. It's easy to see
that the same journal that was supposed to increase filesystem reliability
is CAUSING more unreliable behavior.

