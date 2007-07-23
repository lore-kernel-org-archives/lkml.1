Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbXGWIbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbXGWIbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 04:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbXGWIbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 04:31:01 -0400
Received: from mx1.suse.de ([195.135.220.2]:38311 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbXGWIbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 04:31:00 -0400
To: Tilman Schmidt <tilman@imap.cc>
Cc: LKML <linux-kernel@vger.kernel.org>, g3vbv@blueyonder.co.uk,
       nix.or.die@googlemail.com, jeremy@goop.org
Subject: Re: 2.6.22-git17 boot failure
References: <46A3EC92.3050504@imap.cc> <46A3FBB7.9000608@imap.cc>
From: Andi Kleen <andi@firstfloor.org>
Date: 23 Jul 2007 11:25:52 +0200
In-Reply-To: <46A3FBB7.9000608@imap.cc>
Message-ID: <p73tzrvtqsf.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt <tilman@imap.cc> writes:

> on Mon, 23 Jul 2007 01:47:30 +0200, /me wrote:
> > On my test machine with a Pentium D 940 processor, Intel DQ965GF
> > mainboard and SATA disks, kernel 2.6.22-git17 (32 bit build) fails
> > to come up because it cannot find the disk drives. Same issue
> > with a clone of the 'linus' git tree. Anything known?
> 
> Ok, scrap this. Turns out it wasn't a good idea to answer 'Y' to
> the new XEN config option during "make oldconfig". After changing
> it to CONFIG_XEN=n, all's well again. Sorry for the noise.

Well, xen should not break the boot on a native system, assuming
the configuration without xen is correct. If it does there is a bug
somewhere that needs to be fixed. Can you verify it by reenabling xen on the 
working configuration without changing anything else? 

-Andi

