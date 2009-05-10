Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbZEJWji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbZEJWji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 18:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbZEJWj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 18:39:27 -0400
Received: from tundra.namei.org ([65.99.196.166]:56389 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329AbZEJWj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 18:39:27 -0400
Date: Mon, 11 May 2009 08:37:03 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: roland@redhat.com, chrisw@sous-sol.org, oleg@redhat.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, eparis@redhat.com,
       sds@tycho.nsa.gov
Subject: Re: [PATCH 1/2] CRED: Rename cred_exec_mutex to reflect that it's
 a guard against ptrace
In-Reply-To: <20090508125522.8488.13637.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.2.00.0905110836500.24749@tundra.namei.org>
References: <20090508125522.8488.13637.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, David Howells wrote:

> Rename cred_exec_mutex to reflect that it's a guard against foreign
> intervention on a process's credential state, such as is made by ptrace().  The
> attachment of a debugger to a process affects execve()'s calculation of the new
> credential state - _and_ also setprocattr()'s calculation of that state.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
