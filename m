Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbXJVG6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbXJVG6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 02:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbXJVG6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 02:58:12 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:45899 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbXJVG6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 02:58:11 -0400
Date: Mon, 22 Oct 2007 08:59:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Nix <nix@esperi.org.uk>, Al Viro <viro@ftp.linux.org.uk>,
       Jeff Dike <jdike@addtoit.com>, Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
Message-ID: <20071022065943.GC10864@uranus.ravnborg.org>
References: <87y7dyhv2u.fsf@hades.wkstn.nix> <20071021114854.GF2455@hacking> <20071021130848.GA4621@c2.user-mode-linux.org> <20071021132031.GI2455@hacking> <20071021154346.GW8181@ftp.linux.org.uk> <20071022043746.GF2998@hacking> <20071022052214.GY8181@ftp.linux.org.uk> <20071022061245.GG2998@hacking> <87d4v7fy5i.fsf@hades.wkstn.nix> <20071022065202.GI2998@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022065202.GI2998@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 02:52:02PM +0800, WANG Cong wrote:
> On Mon, Oct 22, 2007 at 07:42:33AM +0100, Nix wrote:
> >On 22 Oct 2007, WANG Cong uttered the following:
> >> I build UML for non-SMP x86. But I don't know about UML_NET_VDE. ;(
> >>
> >> Errors threw out by gcc (too many) are put here:
> >> 	http://wangcong.org/down/errors.txt
> >
> >It's hard to tell without LOCALE=C, but those are the sorts of results
> >I'd expect if you had run make {old,menu,x}config without specifying
> >ARCH=um, so you've configured for one architecture and are now trying
> >to build another.
> >
> >Where is the include/asm symlink pointing to in your build tree?
> 
> $ ls -l include/asm
> lrwxrwxrwx 1 wangcong wangcong 6 2007-10-22 12:34 include/asm -> asm-um
> 
> OK. Let me do the following:
> 
> 	$ make mrproper

Please try
make ARCH=um mrproper

this will clean up the additional uml symlinks.

	Sam
