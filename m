Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbYKFTD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbYKFTD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbYKFTDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:03:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:40624 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbYKFTDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:03:47 -0500
Subject: Re: [PATCH -v2 4/4] AUDIT: emit new record type showing all capset
 information
From: Eric Paris <eparis@redhat.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com, sgrubb@redhat.com,
       morgan@kernel.org, viro@ZenIV.linux.org.uk
In-Reply-To: <20081104165540.GA25093@us.ibm.com>
References: <20081103201742.12059.36030.stgit@paris.rdu.redhat.com>
	 <20081103201759.12059.44897.stgit@paris.rdu.redhat.com>
	 <20081104165540.GA25093@us.ibm.com>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 14:03:38 -0500
Message-Id: <1225998218.3300.171.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-04 at 10:55 -0600, Serge E. Hallyn wrote:
> Quoting Eric Paris (eparis@redhat.com):
> > diff --git a/kernel/capability.c b/kernel/capability.c
> > index 33e51e7..3d7fc70 100644
> > --- a/kernel/capability.c
> > +++ b/kernel/capability.c
> > @@ -7,6 +7,7 @@
> >   * 30 May 2002:	Cleanup, Robert M. Love <rml@tech9.net>
> >   */
> > 
> > +#include <linux/audit.h>
> >  #include <linux/capability.h>
> >  #include <linux/mm.h>
> >  #include <linux/module.h>
> > @@ -457,6 +458,8 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
> >  		i++;
> >  	}
> > 
> > +	audit_log_capset(pid, &effective, &inheritable, &permitted);
> 
> Shouldn't sys_capset() fail if audit_log_capset() returns -ENOMEM?

yes, I think it should, but look for the next e-mail.....

