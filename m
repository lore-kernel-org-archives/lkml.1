Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbXI3ReU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbXI3ReU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 13:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757863AbXI3ReH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 13:34:07 -0400
Received: from mx1.suse.de ([195.135.220.2]:45804 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757773AbXI3ReG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 13:34:06 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: casey@schaufler-ca.com
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
Date: Sun, 30 Sep 2007 19:34:01 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, Paul Moore <paul.moore@hp.com>
References: <984405.24264.qm@web36601.mail.mud.yahoo.com>
In-Reply-To: <984405.24264.qm@web36601.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709301934.01442.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> It does the job going off box, too. 

It does not as far as I can see. The IETF seems to have had very good
reasons to never advance that draft any further.

> The authentication issues are very real, but a separate issue.

First rule of network security: don't trust the network. And you seem
to trust your security to the network which is just double plus bogus.

Without authentication it's completely useless. I don't understand
how you can disregard that as "separate issue". Security is only
secure if you plugged all applicable holes; without that it's useless
and you might as well not bother.

> > It assumes a trusted network which is a very dangerous assumption.  I don't 
> > think that was in the original patch I looked at, I surely would have 
> > objected to it.
> >
> > Perhaps take the network part out? I guess SMACK would be useful
> > locally even without questionable network support.
> 
> That would break sockets. 

You didn't solve sockets security, so they cannot be really broken.

And it's not that network security isn't well understood and well supported
in Linux by various proven subsystems (ipsec, netfilter, ssh, openssl etc.). 

Adding a insecure additional placebo just doesn't seem like a good idea.

> I really doubt that you're suggesting that 
> cryptographic authentication is required on the loopback interface.

For local communication security there are better options like Unix sockets
which can be protected by standard file system protections. And most
networking is not over loopback after all. Only handling loopback is so limited 
that it's bordering to useless.

And again we have plenty of proven networking security solutions anyways.
They all work fine over loopback too. I don't really see what SMACK can add here.

-Andi
 
