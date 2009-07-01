Return-Path: <linux-kernel-owner+w=401wt.eu-S1753298AbZGAPOC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbZGAPOC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 11:14:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZGAPNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 11:13:52 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:36688 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752693AbZGAPNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 11:13:51 -0400
Date: Wed, 1 Jul 2009 23:13:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, Paul Martin <pm@debian.org>
Subject: Re: [Bug #13627] Tunnel device ignores TCP/UDP traffic
Message-ID: <20090701151344.GA4372@gondor.apana.org.au>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera> <6JJ2m5kyucK.A.AtD.NJASKB@chimera> <b6a2187b0907010734w7e7a5bbfm271f44e57e12d1b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6a2187b0907010734w7e7a5bbfm271f44e57e12d1b4@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 10:34:10PM +0800, Jeff Chua wrote:
> On Mon, Jun 29, 2009 at 8:11 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13627
> > Subject         : Tunnel device ignores TCP/UDP traffic
> > Submitter       : Paul Martin <pm@debian.org>
> > Date            : 2009-06-26 14:45 (3 days old)
> 
> I think I'm having the same issue here. Both vpnc and KVM (using tap0)
> not working on 2.6.31-rc1. I think it worked before <2.6.30.
> 
> i've tried the patches as mentioned in
> http://bugzilla.kernel.org/show_bug.cgi?id=13627, but still not
> working.

So you mean that 71f9dacd2e4d233029e9e956ca3f79531f411827 doesn't
work? Does reverting d55d87fdff8252d0e2f7c28c2d443aee17e9d70f help?

If not can you elaborate on what you mean by not working?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
