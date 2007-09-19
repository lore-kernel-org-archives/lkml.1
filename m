Return-Path: <linux-kernel-owner+w=401wt.eu-S1762464AbXISRpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762464AbXISRpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbXISRpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:45:34 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53198 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbXISRpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:45:34 -0400
Subject: Re: [PATCH 03/24] create cleanup helper svc_msnfs()
From: Dave Hansen <haveblue@us.ibm.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org
In-Reply-To: <Pine.LNX.4.64.0709191939080.10201@fbirervta.pbzchgretzou.qr>
References: <20070917182718.70494C9B@kernel>
	 <20070917182721.8EF73A09@kernel>
	 <Pine.LNX.4.64.0709191939080.10201@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 10:45:30 -0700
Message-Id: <1190223930.26982.109.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-19 at 19:39 +0200, Jan Engelhardt wrote:
> 
> >+static inline int svc_msnfs(struct svc_fh *ffhp)
> >+{
> >+#ifdef MSNFS
> >+      return (ffhp->fh_export->ex_flags & NFSEXP_MSNFS);
> >+#else
> >+      return 0;
> >+#endif
> >+}
> 
> The name looks kinda confusing. msnfs? almost makes you think
> what's got microsoft to do with it.. 

I'd give it a better name if I had any idea what it means. :)

The macros and names are all preexisting.  I just took the liberty of
pulling the #ifdef out into a function because the code got very
unreadable with the other modifications that I need.

If it were some kind of larger API, we could come up with something
better.  But, for a single isolated user, I think it is OK.

-- Dave

