Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbXEIIKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbXEIIKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbXEIIKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:10:38 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53514 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbXEIIKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:10:36 -0400
Date: Wed, 9 May 2007 10:11:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>, Matt Domsch <Matt_Domsch@dell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
Message-ID: <20070509081105.GA5857@uranus.ravnborg.org>
References: <464158E9.2000207@zytor.com> <20070509065122.GA5360@uranus.ravnborg.org> <46417215.6060204@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46417215.6060204@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 12:02:45AM -0700, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> >> http://www.kernel.org/pub/linux/kernel/people/hpa/newsetup-36f021b5.patch
> > 
> > Are you planning to rebase to -linus and then let
> > arch/x86_64/boot/Makefile be a reference to i386/boot/Makefile?
> > 
> > The patch for kbuild to enable this is in -linus now.
> > 
> > As for the important part (the code) I have not looked.
> 
> I have rebased to -linus, but I'm a bit scared about making that
> particular change at this time, mostly because it requires some
> additional Makefile work which I would be happier to apply later, in
> order to make the "create clean patchset" task easier.
> 
> All the source code is shared, but for right now the Makefiles are
> slightly different, mostly w.r.t. CFLAGS.

OK, let me know if you want me to take a look at something specific.

	Sam
