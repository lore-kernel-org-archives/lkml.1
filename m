Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbXJZGWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbXJZGWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 02:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756474AbXJZGWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:22:04 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:58289 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752236AbXJZGWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:22:01 -0400
Date: Fri, 26 Oct 2007 08:23:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 0/6] kill i386 and x86_64 directories
Message-ID: <20071026062336.GA19253@uranus.ravnborg.org>
References: <20071025195644.GA14501@uranus.ravnborg.org> <alpine.LFD.0.9999.0710252212420.3186@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0710252212420.3186@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 10:17:53PM +0200, Thomas Gleixner wrote:
> 
> I think the last remaining bit to cleanup is the symlink from
> arch/x86/boot/bzImage. Now that the old directories are gone it does
> not make much sense to keep them alive. Andrew will survive it :)

It is not just Andrew I'm afraid.
We got a Debian bug-report too when we did not have the symlink and I
asume this is true for several others.
We should let it stay in 2.6.24 and remove the symlink for 2.6.25 IMO.

	Sam
