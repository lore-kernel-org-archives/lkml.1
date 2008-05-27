Return-Path: <linux-kernel-owner+w=401wt.eu-S1756044AbYE0BDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbYE0BDO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 21:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbYE0BDC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 21:03:02 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59454 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbYE0BDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 21:03:00 -0400
Subject: Re: [RFC][Patch 5/5]integrity: IMA as an integrity service provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com,
       serue@linux.vnet.ibm.com, sailer@watson.ibm.com, zohar@us.ibm.com,
       Stephen Smalley <sds@tycho.nsa.gov>,
       CaseySchaufler <casey@schaufler-ca.com>
In-Reply-To: <20080523163027.50021215.randy.dunlap@oracle.com>
References: <1211555145.16195.18.camel@new-host>
	 <20080523163027.50021215.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Mon, 26 May 2008 21:02:56 -0400
Message-Id: <1211850176.16742.13.camel@new-host.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-23 at 16:30 -0700, Randy Dunlap wrote:
> On Fri, 23 May 2008 11:05:45 -0400 Mimi Zohar wrote:
> 
> 
> > ---
> > Index: linux-2.6.26-rc3-git2/security/integrity/ima/Kconfig
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6.26-rc3-git2/security/integrity/ima/Kconfig
> > @@ -0,0 +1,68 @@
> > +#
> > +# IBM Integrity Measurement Architecture
> > +#
> > +
> > +config IMA_MEASURE
> > +	bool "TCG run-time Integrity Measurement Architecture(IMA)"
> 
> What is TCG?  It seems to be missing from all of those other TLAs.

TCG stands for Trusted Computing Group.
(https://www.trustedcomputinggroup.org/faq/)

Thank you for reviewing the code. I'll make the kernel doc, Kconfig
and Makefile changes and repost.

Mimi



