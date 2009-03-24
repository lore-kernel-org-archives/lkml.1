Return-Path: <linux-kernel-owner+w=401wt.eu-S1758125AbZCXJPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125AbZCXJPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758395AbZCXJPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:15:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34614 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758074AbZCXJPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:15:32 -0400
Date: Tue, 24 Mar 2009 09:15:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Rees <drees76@gmail.com>
Cc: Jesper Krogh <jesper@krogh.cc>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090324091545.758d00f5@lxorguk.ukuu.org.uk>
In-Reply-To: <72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<49C87B87.4020108@krogh.cc>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> posted to the list earlier trying to see if there was anything that
> could be done to help my specific case.  I've got a system where if
> someone starts writing out a large file, it kills client NFS writes.
> Makes the system unusable:
> http://marc.info/?l=linux-kernel&m=123732127919368&w=2

I have not had this problem since I applied Arjan's (for some reason
repeatedly rejected) patch to change the ioprio of the various writeback
daemons. Under some loads changing to the noop I/O scheduler also seems
to help (as do most of the non default ones)

> Everyone seems to agree that "autotuning" it is the way to go.  But no
> one seems willing to step up and try to do it.  Probably because it's
> hard to get right!

If this is a VM problem why does fixing the I/O priority of the various
daemons seem to cure at least some of it ?

Alan
