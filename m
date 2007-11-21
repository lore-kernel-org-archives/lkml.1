Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbXKUP60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbXKUP60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 10:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXKUP6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 10:58:18 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:56432 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753604AbXKUP6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 10:58:17 -0500
Subject: Re: +
	smack-version-11c-simplified-mandatory-access-control-kernel.patch added to
	-mm tree
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, casey@schaufler-ca.com, chrisw@sous-sol.org,
       darwish.07@gmail.com, jmorris@namei.org, method@manicmethod.com,
       morgan@kernel.org, paul.moore@hp.com
In-Reply-To: <20071121154849.GA7195@sergelap.austin.ibm.com>
References: <200711202206.lAKM6BlW025868@imap1.linux-foundation.org>
	 <20071121154849.GA7195@sergelap.austin.ibm.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 21 Nov 2007 10:51:59 -0500
Message-Id: <1195660319.759.50.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-21 at 09:48 -0600, Serge E. Hallyn wrote:
> Quoting akpm@linux-foundation.org (akpm@linux-foundation.org):
> > +/*
> > + * There are not enough CAP bits available to make this
> > + * real, so Casey borrowed the capability that looks to
> > + * him like it has the best balance of similarity amd
> > + * low use.
> > + */
> > +#define CAP_MAC_OVERRIDE CAP_LINUX_IMMUTABLE
> 
> Hey Casey,
> 
> note that 64-bit capabilities are now in -mm, so you could grab your own
> capability.

Which brings up an interesting question - what to do with
security-module-specific capabilities?  CAP_MAC_OVERRIDE is specific to
Smack - other MAC modules like SELinux won't honor it.  Maybe it should
be CAP_SMACK_OVERRIDE.

-- 
Stephen Smalley
National Security Agency

