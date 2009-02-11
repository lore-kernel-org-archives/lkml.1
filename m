Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbZBKAti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbZBKAti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 19:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757962AbZBKAa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 19:30:29 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58997 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756450AbZBKAa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 19:30:27 -0500
In-Reply-To: <20090211094050.47c4828d.sfr@canb.auug.org.au>
References: <20090210194121.80256b72.sfr@canb.auug.org.au>	<4991DBA0.1000008@oracle.com> <20090211094050.47c4828d.sfr@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: linux-next: Tree for February 10 (security/audit/ima)
X-KeepSent: F3345B15:9471295A-8525755A:00024CFE;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OFF3345B15.9471295A-ON8525755A.00024CFE-8525755A.0002C8E8@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Tue, 10 Feb 2009 19:30:24 -0500
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.5|December 05, 2008) at
 02/10/2009 19:30:24,
	Serialize complete at 02/10/2009 19:30:24
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote on 02/10/2009 05:40:50 PM:

> Hi Randy,
> 
> On Tue, 10 Feb 2009 11:55:12 -0800 Randy Dunlap 
<randy.dunlap@oracle.com> wrote:
> >
> > Stephen Rothwell wrote:
> > > 
> > > Dropped trees (temporarily):
> > >    audit (difficult conflicts)
> > 
> > Maybe this is fixed by the dropped audit tree?
> 
> The audit tree is Al Viro's (cc'd).  But I *think* everything in it has
> been applied upstream.
> 
> > linux-next-20090210/security/integrity/ima/ima_policy.c:111: error: 
implicit
> declaration of function 'security_audit_rule_match'
> > linux-next-20090210/security/integrity/ima/ima_policy.c:230: error: 
implicit
> declaration of function 'security_audit_rule_init'
> > 
> > when
> > CONFIG_SECURITY=y
> > CONFIG_AUDIT=n
> > CONFIG_IMA=y
> > CONFIG_IMA_AUDIT=y
> 
> This looks more like a security subsystem than audit to me?

These are the IMA Kconfig rules:
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_IMA_LSM_RULES=y

CONFIG_IMA_LSM_RULES requires the audit subsystem.  The default
measurement policy is not defined terms of the LSM extended
attributes, and thus is not required.

Mimi


