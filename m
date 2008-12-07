Return-Path: <linux-kernel-owner+w=401wt.eu-S1759098AbYLGWvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098AbYLGWvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 17:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757819AbYLGWr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 17:47:29 -0500
Received: from tundra.namei.org ([65.99.196.166]:46192 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916AbYLGWrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 17:47:24 -0500
Date: Mon, 8 Dec 2008 09:46:51 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       David Howells <dhowells@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] user namespaces: let user_ns be cloned with
 fairsched
In-Reply-To: <20081203191706.GA16433@us.ibm.com>
Message-ID: <alpine.LRH.1.10.0812080946360.23851@tundra.namei.org>
References: <20081203191706.GA16433@us.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008, Serge E. Hallyn wrote:

> (These two patches are in the next-unacked branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/userns-2.6.
> If they get some ACKs, then I hope to feed this into security-next.
> After these two, I think we're ready to tackle userns+capabilities)
> 
> Fairsched creates a per-uid directory under /sys/kernel/uids/.
> So when you clone(CLONE_NEWUSER), it tries to create
> /sys/kernel/uids/0, which already exists, and you get back
> -ENOMEM.
> 
> This was supposed to be fixed by sysfs tagging, but that
> was postponed (ok, rejected until sysfs locking is fixed).
> So, just as with network namespaces, we just don't create
> those directories for user namespaces other than the init.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
