Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYFASOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYFASOt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 14:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYFASOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 14:14:42 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52938 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYFASOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 14:14:41 -0400
Date: Sun, 1 Jun 2008 19:14:00 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>, tytso@mit.edu,
       benh@kernel.crashing.org,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, seife@suse.de
Subject: Re: s2ram video problems Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Message-ID: <20080601181359.GA26477@srcf.ucam.org>
References: <20080529124548.GC8065@mit.edu> <20080529.135431.235149338.davem@davemloft.net> <20080529211404.GH8065@mit.edu> <20080529.143921.34376298.davem@davemloft.net> <alpine.LFD.1.10.0806011605590.3235@apollo.tec.linutronix.de> <1212330249.3373.20.camel@localhost.localdomain> <20080601162150.GC5555@ucw.cz> <1212343465.3373.60.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212343465.3373.60.camel@localhost.localdomain>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2008 at 01:04:25PM -0500, James Bottomley wrote:

> This, by the way was years ago, beginning with FC6.  In FC7 we got the
> driver to the state where vbestate save/restore worked for it and added
> it to the hal database.  Today, at FC9, I've just been busy filing a bug
> with fedora because the i915 drm now seems to do everything and actively
> screws up if vbestate save/restore is used (so all the work I did with
> FC7/8 now needs to be undone).

Fixed in pm-utils upstream, which knows not to do anything with recent 
Intel drm. The trick now is to get nvidia and amd to the same level of 
functionality, though in principle we know enough to manage at least the 
nvidia case.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
