Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbXJVFW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbXJVFW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 01:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbXJVFWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 01:22:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36473 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbXJVFWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 01:22:21 -0400
Date: Mon, 22 Oct 2007 06:22:14 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@addtoit.com>, Nix <nix@esperi.org.uk>,
       Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
Message-ID: <20071022052214.GY8181@ftp.linux.org.uk>
References: <200710111754.46854.rob@landley.net> <200710200252.37919.p.giarrusso@gmail.com> <87y7dyhv2u.fsf@hades.wkstn.nix> <20071021114854.GF2455@hacking> <20071021130848.GA4621@c2.user-mode-linux.org> <20071021132031.GI2455@hacking> <20071021154346.GW8181@ftp.linux.org.uk> <20071022043746.GF2998@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022043746.GF2998@hacking>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 12:37:46PM +0800, WANG Cong wrote:
> >Fallout continues; I've got a preliminary patch for it.  Basically, we
> >need to stop doing -U__i386__ et.al.
> >
> 
> Hi, Al.
> 
> I applied your patch and recompiled the kernel. But it failed again.
> ;(

Details would be welcome...  Notes: SMP on UML is no more; UML_NET_VDE
depends on having some userland library installed.  Aside of those two
it ought to build.

Build log on failing build would be nice, along with .config.
