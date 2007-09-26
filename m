Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbXIZODy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbXIZODy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 10:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbXIZODq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 10:03:46 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33979 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754149AbXIZODp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 10:03:45 -0400
Date: Wed, 26 Sep 2007 15:09:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Miloslav Semler <majkls@prepere.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
Message-ID: <20070926150951.2d8c2705@the-village.bc.nu>
In-Reply-To: <46FA43DD.7090703@prepere.com>
References: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at>
	<46F29A9A.4070806@davidnewall.com>
	<200709201817.17282@x5>
	<46F2B59F.8090709@davidnewall.com>
	<46F2DDD0.3030500@tmr.com>
	<46F380E4.4040606@davidnewall.com>
	<20070924213215.GA32716@vino.hallyn.com>
	<46F83474.5040503@davidnewall.com>
	<20070924230008.GA3160@vino.hallyn.com>
	<46F8BC8A.7080006@davidnewall.com>
	<20070925114947.GA9721@vino.hallyn.com>
	<46F91417.9050600@davidnewall.com>
	<46F924E3.50205@davidnewall.com>
	<20070925163040.12a3c2f8@the-village.bc.nu>
	<46F92AAB.1060903@davidnewall.com>
	<20070925164806.4cadc6a5@the-village.bc.nu>
	<46F99EDE.70905@davidnewall.com>
	<20070926011847.49bbb9a2@the-village.bc.nu>
	<46FA334F.7030802@davidnewall.com>
	<20070926114729.3b9d1fb4@the-village.bc.nu>
	<46FA3D4B.20805@davidnewall.com>
	<20070926122028.5f842d1e@the-village.bc.nu>
	<46FA41B4.9040104@prepere.com>
	<20070926123522.54ffd56f@the-village.bc.nu>
	<46FA43DD.7090703@prepere.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 13:34:53 +0200
Miloslav Semler <majkls@prepere.com> wrote:

> Alan Cox napsal(a):
> >> but many program use this as security feature. So do you think that bind 
> >> may use vserver?
> >>     
> >
> > It would be a lot stronger if it did. A bind running non-root will be
> > probably safe. A bind running as root can be attacked and break out of a
> > chroot trivially. I guess it depends how you run bind.
> >   
> but not bind with selinux. It can chroot, but not  does other things. So 
> there is an question: Why we do not fix it. Tell me please some other 
> reason than "you can workaround chroot other ways".

If you are using SELinux you don't need chroot for the security in the
first place you can use labels and LSM modules can also handle things
like ptrace which permit trivial escapes.

Alan
