Return-Path: <linux-kernel-owner+w=401wt.eu-S968464AbXEIGui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968464AbXEIGui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 02:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbXEIGu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 02:50:29 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33769 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbXEIGu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 02:50:29 -0400
Date: Wed, 9 May 2007 08:51:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>, Matt Domsch <Matt_Domsch@dell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
Message-ID: <20070509065122.GA5360@uranus.ravnborg.org>
References: <464158E9.2000207@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464158E9.2000207@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 10:15:21PM -0700, H. Peter Anvin wrote:
> Hello all,
> 
> I believe the x86 setup tree is now finished.  I will turn it into a
> "clean patchset" later this week, but I wanted to get flamed^W feedback
> on it first.
> 
> The git tree is at:
> 
> http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-newsetup.git;a=summary
> git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-newsetup.git
> ...
> 
> ... and a flat patch at ...
> 
> http://www.kernel.org/pub/linux/kernel/people/hpa/newsetup-36f021b5.patch

Are you planning to rebase to -linus and then let
arch/x86_64/boot/Makefile be a reference to i386/boot/Makefile?

The patch for kbuild to enable this is in -linus now.

As for the important part (the code) I have not looked.

	Sam
