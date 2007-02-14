Return-Path: <linux-kernel-owner+w=401wt.eu-S932196AbXBNKt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbXBNKt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:49:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932200AbXBNKt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:49:58 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:17021 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbXBNKt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:49:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:sender;
        b=bkQ/oiHZJAv1gDzaOISNzXqQ/mXqDBXCTlhJkS5OR5aAV57IHPGWWf//LLfnBj0uCypcxPCAmYQQ0/OkIl+FzTcyvDgTF/HgiodUpc/dWIdmpiT5UCrpNAPBYQftz/v3Eqi7LhEnq5zaSPWqdJhQNvSH0jcSt6fChBYGWHq8NL0=
From: Eric Lacombe <tuxiko@free.fr>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: Linux 2.6.19.2: maybe a bug inside the r8169 network driver (was Re: Linux 2.6.19.2: Freeze with CIFS mount)
Date: Wed, 14 Feb 2007 11:49:52 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steve French <sfrench@us.ibm.com>, Eric Lacombe <tuxiko@free.fr>
References: <OFC7B98576.0C582E30-ON87257274.0014583D-86257274.00153815@us.ibm.com> <200702131452.05473.tuxiko@free.fr> <20070213203047.GA4158@electric-eye.fr.zoreil.com>
In-Reply-To: <20070213203047.GA4158@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702141149.53041.tuxiko@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 February 2007 21:30:47 Francois Romieu wrote:
> Eric Lacombe <tuxiko@free.fr> :
> [...]
>
> > That problem also remind me that when I compiled this driver without
> > the "CONFIG_NET_ETHERNET" (in the section "Ethernet (10 or 100Mbit)"), I
> > have really poor performance with the net device. Maybe it is related, or
> > not ;)
> >
> > If it gives you more ideas ?
> > Maybe it could be interesting to know about the r8169 maintainer, but I
> > dont know who he is.
>
> 1. $ ls
>    arch     crypto         include  kernel       mm              scripts
>    block    Documentation  init     lib          net             security
>    COPYING  drivers        ipc      MAINTAINERS  README          sound
>    CREDITS  fs             Kbuild   Makefile     REPORTING-BUGS  usr
>
>    The maintainer of the r8169 driver is listed in the MAINTAINERS file.

I see, thanks ;)

(I thought the MAINTAINERS file was not fully maintained ;)

>
> 2. Disabling CONFIG_NET_ETHERNET is a bad idea. Don't do that.

ok, but why having it only inside the "ethernet 100" menu ?
It is misleading, no ?

>
> 3. See tethereal -w or tcpdump on the adequate interface to save a
>    traffic dump.

yep, but the problem is that I cant do that from the NAS Box. I will try to 
monitor the traffic via the system that will freeze... For the moment I can't 
monitor the net traffic from an alternate PC, but soon.

>
> 4. Are you using a binary module for your video adapter ?

yes, I suppose that I have to unload this one before doing further tests.

>
> 5. How does the 2.6.20 version of the r8169 driver behave ?

I don't have installed it yet, but I'll do it this evening.

>
> 6. You may setup a cron to monitor an ethtool dump of the register of
>    the 8169 at regular interval. ifconfig and /proc/interrupts could
>    exhibit some unusual drift as time passes on too.

I will do that. When I could put a third system to monitor the traffic, I will 
make "the system that freeze" keep sending that information to it.

>
> 7. A dmesg would be welcome.

I could do that, this evening.

>
> 8. Please open a PR at bugzilla.kernel.org.

ok

>
> |...]
> |
> > > There are various ways to analyze system hangs including (at least in
> > > some cases) getting a system dump which
> > > can be used to isolate the failing location - hopefully
> >
> > I would like to have more detailed help, if possible.
>
> CONFIG_MAGIC_SYSRQ is set. Check that the magic sysrq is not disabled at
> runtime through /etc/sysctl.conf. See Documentation/sysrq.txt for details.

ok

>
> Please keep Steve French in the loop.

ok

Thanks for your response ;)

	Eric
