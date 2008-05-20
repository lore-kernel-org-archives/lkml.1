Return-Path: <linux-kernel-owner+w=401wt.eu-S1764256AbYETABV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764256AbYETABV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbYETABN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:01:13 -0400
Received: from namei.org ([69.55.235.186]:39560 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756277AbYETABM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:01:12 -0400
Date: Tue, 20 May 2008 10:01:05 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] selinux: reorder inode_security_struct to increase
 objs/slab on 64bit
In-Reply-To: <1211197185.7486.0.camel@moss-spartans.epoch.ncsc.mil>
Message-ID: <Xine.LNX.4.64.0805201000460.8661@us.intercode.com.au>
References: <1211110377.3021.8.camel@castor.localdomain>
 <1211197185.7486.0.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008, Stephen Smalley wrote:

> >  	u32 sid;		/* SID of this object */
> >  	u16 sclass;		/* security class of this object */
> >  	unsigned char initialized;	/* initialization flag */
> > -	struct mutex lock;
> >  	unsigned char inherit;	/* inherit SID from parent entry */
> 
> Let's just drop inherit altogether - dead field.

Done in 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/selinux-2.6.git#for-akpm

-- 
James Morris <jmorris@namei.org>

