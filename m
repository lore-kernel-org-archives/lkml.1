Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbXKZAr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbXKZAr6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 19:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757095AbXKZArt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 19:47:49 -0500
Received: from nef2.ens.fr ([129.199.96.40]:3809 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbXKZArs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 19:47:48 -0500
Date: Mon, 26 Nov 2007 01:47:46 +0100
From: David Madore <david.madore@ens.fr>
To: Linux Kernel Mailing-List <linux-kernel@vger.kernel.org>
Subject: setting the init process's personality?
Message-ID: <20071126004746.GA11281@clipper.ens.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Mon, 26 Nov 2007 01:47:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Is there a simple way (via a kernel boot option or config setting or -
if really necessary - a patch or something like that) to set the
personality for the init process?  I'm running an x86_64 kernel on a
system whose userland is almost entirely 32-bits (but needs an
occasional 64-bit process to be run, hence the choice of kernel), and
I'd like `uname -m` to be i686 unless I take special action.  So I
think that means letting init (which is indeed a 32-bit process) have
the PER_LINUX32 personality (in case I'm wrong about this, the output
of uname -m is essentially what matters to me).

So, where does the default come from?

-- 
     David A. Madore
    (david.madore@ens.fr,
     http://www.madore.org/~david/ )
