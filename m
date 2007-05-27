Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbXE0AVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbXE0AVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 20:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbXE0AU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 20:20:59 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:45860 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750855AbXE0AU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 20:20:58 -0400
Date: Sun, 27 May 2007 02:20:52 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jay Cliburn <jacliburn@bellsouth.net>
Cc: gregkh@suse.de, chrisw@sous-sol.org, csnook@redhat.com,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable][PATCH] pci: quirk disable MSI on via vt3351
Message-ID: <20070527002052.GM3899@stusta.de>
References: <20070526220104.GA11530@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070526220104.GA11530@osprey.hogchain.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 05:01:04PM -0500, Jay Cliburn wrote:
> 
> The Via VT3351 APIC does not play well with MSI and unleashes a flood
> of APIC errors when MSI is used to deliver interrupts.  The problem
> was recently exposed when the atl1 network device driver, which enables
> MSI by default, stimulated APIC errors on an Asus M2V mainboard, which
> employs the Via VT3351.
> See http://bugzilla.kernel.org/show_bug.cgi?id=8472 for additional
> details on this bug.
>...

Please get patches included in Linus' tree _before_ submitting them for 
-stable.

Adding a fix to 2.6.21 that is not yet in 2.6.22-rc would create a 
regression in 2.6.22.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

