Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbYHVWpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbYHVWpS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 18:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbYHVWpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 18:45:04 -0400
Received: from tundra.namei.org ([65.99.196.166]:47035 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbYHVWpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 18:45:02 -0400
Date: Sat, 23 Aug 2008 08:44:30 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: a.beregalov@gmail.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] CRED: Further fix execve cred_exec_mutex handling [ver
 #2]
In-Reply-To: <20080822134636.5797.34406.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.1.10.0808230844080.24779@tundra.namei.org>
References: <20080822134636.5797.34406.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008, David Howells wrote:

> Further fix the way cred_exec_mutex is handled by [compat_]do_execve().  The
> mutex is now only unlocked by the function that locked it, and is no longer
> unlocked by free_bprm() or install_exec_creds().  This means that PTRACE_ATTACH
> may have to wait a little longer before being allowed to proceed.
> 
> This patch cleans up the order in which the mutex is locked and unlocked and
> gets rid of a potential double unlock.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---

Applied to:
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-creds


-- 
James Morris
<jmorris@namei.org>
