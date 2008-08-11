Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYHKORa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYHKORa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 10:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYHKORW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 10:17:22 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42784 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYHKORV (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:17:21 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, rostedt@goodmis.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] printk: robustify printk
In-Reply-To: Your message of "Mon, 11 Aug 2008 13:42:43 +0200."
             <20080811114243.GO9038@one.firstfloor.org>
From: Valdis.Kletnieks@vt.edu
References: <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org> <1218217257.29098.2.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org> <1218219269.29098.5.camel@lappy.programming.kicks-ass.net> <20080808121428.646a8b3c.akpm@linux-foundation.org> <1218223269.29098.12.camel@lappy.programming.kicks-ass.net> <1218224829.29098.19.camel@lappy.programming.kicks-ass.net> <20080811104526.GA15186@elte.hu> <87zlnj24qc.fsf@basil.nowhere.org> <1218453726.10800.63.camel@twins>
            <20080811114243.GO9038@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1218464121_9495P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 11 Aug 2008 10:15:21 -0400
Message-ID: <22551.1218464121@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1218464121_9495P
Content-Type: text/plain; charset=us-ascii

On Mon, 11 Aug 2008 13:42:43 +0200, Andi Kleen said:
> On Mon, Aug 11, 2008 at 01:22:06PM +0200, Peter Zijlstra wrote:
> > You only loose the msgs with klogd, console still gets everything. If
> > firewalls are generating that much data, perhaps its time to think about
> > alternative ways to channel that.
> 
> Yes, and netfilter has them in fact, but it's clearly still a regression for 
> people who rely on klogd for this today.
> 
> Also firewall is just an example. Other cases might be people relying
> on these selinux messages. Or some other kernel messages.

Similar to "netfilter has other ways", the SELinux messages have another
defined way as well.  If your site is high-security and *depends* on the
messages, the *right* answer is to run auditd to catch and log the messages,
and configure auditd to bring the system to a screeching halt if the
log space fills up or there's other problems (yes, some sites would rather
have the machine drop dead than possibly miss an SELinux message).

--==_Exmh_1218464121_9495P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIoEl5cC3lWbTT17ARAiLcAJ4udSOBjHfBIVa0hwCBlYcWKqcLTQCgmTG0
8zLnnZ3nAiJKR++gjSemmbw=
=nVxd
-----END PGP SIGNATURE-----

--==_Exmh_1218464121_9495P--
