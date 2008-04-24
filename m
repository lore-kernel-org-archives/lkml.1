Return-Path: <linux-kernel-owner+w=401wt.eu-S1761029AbYDXTRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761029AbYDXTRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 15:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759273AbYDXTQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 15:16:59 -0400
Received: from kolab.mylinuxtime.de ([212.112.242.22]:33881 "EHLO
	kolab.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272AbYDXTQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 15:16:58 -0400
X-Spam-ASN: 
From: Christian Hesse <mail@earthworm.de>
To: Jeff Arnold <jbarnold@mit.edu>
Subject: Re: A system for rebootless kernel security updates
Date: Thu, 24 Apr 2008 21:16:49 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <alpine.DEB.1.00.0802221606520.21343@vinegar-pot.mit.edu> <200804241543.06874.mail@earthworm.de> <alpine.DEB.1.00.0804241306260.21001@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.1.00.0804241306260.21001@vinegar-pot.mit.edu>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804242116.54019.mail@earthworm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 April 2008, Jeff Arnold wrote:
> > I just wanted to test on my Gentoo system with kernel 2.6.25. The
> > tarball creation works, but applying the change brings an error to
> > syslog
>
> Sorry.  (In 2.6.25, init_mm is marked as an unused symbol, and so whether
> it is exported depends on whether CONFIG_UNUSED_SYMBOLS is enabled).
>
> I've committed a change which should fix this problem.  You can get get
> the new version (0.8.1) from http://web.mit.edu/ksplice/dist/ or from Git.
> (I haven't yet made the new version the default, so you won't receive it
> from the main Ksplice page).

This time I get the following in syslog:

ksplice_h: Preparing and checking ksplice_oq7ne7l6
ksplice: Aborted. (stack check: to-be-replaced code is busy)

I tried the example from your website (modifying printk).
-- 
Regards,
Chris
