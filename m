Return-Path: <linux-kernel-owner+w=401wt.eu-S1759229AbYLGWv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229AbYLGWv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 17:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758300AbYLGWrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 17:47:37 -0500
Received: from tundra.namei.org ([65.99.196.166]:46196 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758281AbYLGWrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 17:47:36 -0500
Date: Mon, 8 Dec 2008 09:47:21 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: "Serge E. Hallyn" <serue@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] user namespaces: require cap_set{ug}id for
 CLONE_NEWUSER
In-Reply-To: <m1r64mpmsi.fsf@frodo.ebiederm.org>
Message-ID: <alpine.LRH.1.10.0812080947050.23851@tundra.namei.org>
References: <20081203191706.GA16433@us.ibm.com> <20081203191733.GA16652@us.ibm.com> <m1r64mpmsi.fsf@frodo.ebiederm.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008, Eric W. Biederman wrote:

> "Serge E. Hallyn" <serue@us.ibm.com> writes:
> 
> > While ideally CLONE_NEWUSER will eventually require no
> > privilege, the required permission checks are currently
> > not there.  As a result, CLONE_NEWUSER has the same effect
> > as a setuid(0)+setgroups(1,"0").  While we already require
> > CAP_SYS_ADMIN, requiring CAP_SETUID and CAP_SETGID seems
> > appropriate.
> 
> Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> The patch looks good, and we are likely to need more caps to
> actually use it.

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
