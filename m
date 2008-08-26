Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbYHZIrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbYHZIrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYHZIr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:47:26 -0400
Received: from tundra.namei.org ([65.99.196.166]:55058 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbYHZIr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:47:26 -0400
Date: Tue, 26 Aug 2008 18:46:58 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: akpm@linux-foundation.org, harvey.harrison@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRED: Document the credential API's (ab)use of const
 pointers
In-Reply-To: <20080821135224.17166.32291.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.1.10.0808261846400.6116@tundra.namei.org>
References: <20080821135224.17166.32291.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008, David Howells wrote:

> Document the credential API's (ab)use of const pointers.  Various pointers to
> credentials, such as those in the task_struct, are declared const.  The purpose
> of this is to compile-time discouragement of altering credentials through those
> pointers.  Once a set of credentials has been made public through one of these
> pointers, it may not be modified, except under special circumstances:
> 
>   (1) Its reference count may incremented and decremented.
> 
>   (2) The keyrings to which it points may be modified, but not replaced.
> 
> The only safe way to modify anything else is to create a replacement and commit
> using the functions described in Documentation/credentials.txt.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next-creds


-- 
James Morris
<jmorris@namei.org>
