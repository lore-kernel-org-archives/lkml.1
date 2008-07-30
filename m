Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbYG3VxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbYG3VxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbYG3VxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:53:13 -0400
Received: from namei.org ([69.55.235.186]:47977 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752349AbYG3VxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:53:11 -0400
Date: Thu, 31 Jul 2008 07:52:42 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] vfs: make security_inode_setattr() calling consistent
In-Reply-To: <1217428647.20373.235.camel@moss-spartans.epoch.ncsc.mil>
Message-ID: <Xine.LNX.4.64.0807310736520.28737@us.intercode.com.au>
References: <E1KOARi-0004wu-1G@pomaz-ex.szeredi.hu>
 <1217428647.20373.235.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, Stephen Smalley wrote:

> Unfortunate since we'd prefer to have the DAC checks applied first, and
> since inode_change_ok() may alter the ia_mode in response to those
> checks, but it does seem inconsistent at present and it doesn't yield
> any difference in the ltp selinux testsuite results.

No LSM seems to be using ia_mode, so that aspect is ok.  The DAC checks 
are generally not being applied first currently, so common case behaviour 
doesn't change with this patch.

Acked-by: James Morris <jmorris@namei.org>

-- 
James Morris
<jmorris@namei.org>
