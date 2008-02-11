Return-Path: <linux-kernel-owner+w=401wt.eu-S1757058AbYBKKpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbYBKKpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 05:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbYBKKoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 05:44:55 -0500
Received: from namei.org ([69.55.235.186]:49907 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753039AbYBKKox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 05:44:53 -0500
Date: Mon, 11 Feb 2008 21:43:47 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: David Howells <dhowells@redhat.com>
cc: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/37] Security: Separate task security context from
 task_struct
In-Reply-To: <20080208165229.15902.75572.stgit@warthog.procyon.org.uk>
Message-ID: <Xine.LNX.4.64.0802112142370.27028@us.intercode.com.au>
References: <20080208165156.15902.62457.stgit@warthog.procyon.org.uk>
 <20080208165229.15902.75572.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, David Howells wrote:

> Separate the task security context from task_struct.  At this point, the
> security data is temporarily embedded in the task_struct with two pointers
> pointing to it.
> 
> Alpha needs further alteration as it refers to UID & GID in entry.S via asm
> offsets.
> 
> Sparc needs further alteration as it refers to UID & GID in sclow.S via asm
> offsets.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Reviewed-by: James Morris <jmorris@namei.org>

(SELinux stuff mostly).

-- 
James Morris
<jmorris@namei.org>
