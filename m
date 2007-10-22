Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbXJVLgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbXJVLgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 07:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbXJVLgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 07:36:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37786 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbXJVLgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 07:36:06 -0400
Date: Mon, 22 Oct 2007 12:36:00 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Nix <nix@esperi.org.uk>,
       Jeff Dike <jdike@addtoit.com>, Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
Message-ID: <20071022113600.GA8181@ftp.linux.org.uk>
References: <20071021130848.GA4621@c2.user-mode-linux.org> <20071021132031.GI2455@hacking> <20071021154346.GW8181@ftp.linux.org.uk> <20071022043746.GF2998@hacking> <20071022052214.GY8181@ftp.linux.org.uk> <20071022061245.GG2998@hacking> <87d4v7fy5i.fsf@hades.wkstn.nix> <20071022065202.GI2998@hacking> <20071022065943.GC10864@uranus.ravnborg.org> <20071022074823.GJ2998@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022074823.GJ2998@hacking>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 03:48:23PM +0800, WANG Cong wrote:
> I just followed what Sam told me, errors are much fewer this time,
> but still exist. Error messages are:
> 
>   CC      arch/um/kernel/syscall.o
>   CC      arch/um/kernel/sysrq.o
> arch/um/kernel/sysrq.c: In function ???show_stack???:
> arch/um/kernel/sysrq.c:63: error: ???UESP??? undeclared (first use in this function)
> arch/um/kernel/sysrq.c:63: error: (Each undeclared identifier is reported only once
> arch/um/kernel/sysrq.c:63: error: for each function it appears in.)
> make[1]: *** [arch/um/kernel/sysrq.o] Error 1
> make: *** [arch/um/kernel] Error 2
> 
> Or I missed something again?
> 
> And I use `make defconfig ARCH=um' to generate .config, my tree
> is 2.6.23-git16 (Al, is this OK?).

Now apply the patch upthread, it should've fixed that one (and yes, you
are down to the stuff this patch is supposed to fix - and does so here).
