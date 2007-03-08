Return-Path: <linux-kernel-owner+w=401wt.eu-S933036AbXCHSsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036AbXCHSsj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933038AbXCHSsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:48:39 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49274 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933036AbXCHSsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:48:38 -0500
Date: Thu, 8 Mar 2007 12:46:47 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 1/6] integrity: new hooks
Message-ID: <20070308184646.GC21099@sergelap.austin.ibm.com>
References: <20070308170001.GA17304@sergelap.austin.ibm.com> <33939.11500.qm@web36612.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33939.11500.qm@web36612.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Casey Schaufler (casey@schaufler-ca.com):
> 
> --- "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
> 
> > It's unfortunate, agreed, but
> > 
> > use of LSM as an integrity framework was also a
> > no-go.
> 
> You're going to have to justify this assertion.

You misunderstand.  I wasn't saying it wouldn't work :)  I was saying
that it's been said repeatedly that evm should be implemented as an
integrity, not security, module.

I think it should be done as both.  The part which measures the
integrity of files should be an integrity subsystem.  The part which
uses those results to either allow/refuse actions or take some other
action (i.e. shut down the system) should be an lsm.

> I know of at least one work-in-progress for which
> LSM works just fine. Not to mention the Integrity
> claims of SELinux.

-serge
