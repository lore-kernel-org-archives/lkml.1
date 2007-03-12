Return-Path: <linux-kernel-owner+w=401wt.eu-S1751110AbXCLWeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110AbXCLWeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbXCLWeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:34:46 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:38656 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXCLWep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:34:45 -0400
Subject: Re: [RFC] [Patch 1/1] IBAC Patch
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: linux-security-module@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, kjhall@linux.vnet.ibm.com, zohar@us.ibm.com,
       linux-kernel@vger.kernel.org, disec-devel@lists.sourceforge.net
In-Reply-To: <200703090319.l293JrpC009714@turing-police.cc.vt.edu>
References: <1173394696.5981.12.camel@localhost.localdomain>
	 <200703090319.l293JrpC009714@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 17:47:20 -0400
Message-Id: <1173736041.5803.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 22:19 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 08 Mar 2007 17:58:16 EST, Mimi Zohar said:
> > This is a request for comments for a new Integrity Based Access
> > Control(IBAC) LSM module which bases access control decisions
> > on the new integrity framework services. 
> > 
> > (Hopefully this will help clarify the interaction between an LSM 
> > module and LIM module.)
> 
> OK, between this and the additional LIM hooks I didn't notice in an earlier
> patch, we're starting to see the API.   The only problem is that although
> it may be the right API for *your* code, I suspect it's a non-starter without
> a discussion about whether it's the right *generic* API for an LIM (which will
> require at least one dramatic bun fight about what "Integrity" means).

Absolutely, we need to make sure that the set of LIM hooks is complete and that
nothing is missing in order to implement different types of LIM providers.  I'm 
copying the digsig mailing list for their input on requirements, which this API 
might not satisfy or perhaps address.

> > Index: linux-2.6.21-rc3-mm2/security/ibac/Kconfig
> 
> Minor congnitive-dissonance alert:
> 
> > +config SECURITY_IBAC_BOOTPARAM
> > +	bool "IBAC boot parameter"
> > +	depends on SECURITY_IBAC
> > +	default y
> 
> > +	  If you are unsure how to answer this question, answer N.
> 
> The 'default' should in general match the hint we give the user.

Oops, blush.  It will obviously be corrected in the next IBAC patch
release.

Mimi Zohar

