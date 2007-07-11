Return-Path: <linux-kernel-owner+w=401wt.eu-S1763774AbXGKMPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763774AbXGKMPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759729AbXGKMPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:15:07 -0400
Received: from ns2.suse.de ([195.135.220.15]:49422 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758967AbXGKMPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:15:05 -0400
To: Stefano Rivoir <s.rivoir@gts.it>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
	<4693327E.6000006@gts.it>
	<alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org>
	<46947ADF.4080605@gts.it>
From: Andi Kleen <andi@firstfloor.org>
Date: 11 Jul 2007 15:10:10 +0200
In-Reply-To: <46947ADF.4080605@gts.it>
Message-ID: <p73vecrxf0t.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefano Rivoir <s.rivoir@gts.it> writes:

> Linus Torvalds wrote:
> > On Tue, 10 Jul 2007, Stefano Rivoir wrote:
> >> 2.6.22 hangs at boot on my box. Here attached a original dmesg from 2.6.21,
> >> and a copy of it where it stops on 2.6.22 (I can't attach the original 2.6.22
> >> dmesg because it's not logged to disk yet); it actually stops right after
> >> 'init' launches.
> > Ok, without any oops or hang in any really obvious place, that
> > doesn't really tell anybody anything specific enough to even start
> > trying to debug this, so you'd need to do one of two things:
> 
> Hi,
> 
> Ok, the guilty bit is gcc: in my box, compiling kernel with gcc 4.2.x
> (which is installed on my debian/sid) turns into a hang (in init,
> seemingly, maybe not even in kernel itself), while gcc-4.1 is allright.

The standard way to track this down is to compile different directories
of the kernel with different gcc versions. Then when you find the directory
go down to files. Then you could eventually go down to functions, although
that tends to involve quite some editing work. But already knowing
the file would be useful.

-Andi
