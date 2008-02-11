Return-Path: <linux-kernel-owner+w=401wt.eu-S1757704AbYBKLAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704AbYBKLAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 06:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754670AbYBKLA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 06:00:28 -0500
Received: from namei.org ([69.55.235.186]:50466 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754217AbYBKLA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 06:00:27 -0500
Date: Mon, 11 Feb 2008 21:59:07 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: David Howells <dhowells@redhat.com>
cc: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 08/37] Security: Add a kernel_service object class to
 SELinux
In-Reply-To: <20080208165240.15902.64781.stgit@warthog.procyon.org.uk>
Message-ID: <Xine.LNX.4.64.0802112157590.27028@us.intercode.com.au>
References: <20080208165156.15902.62457.stgit@warthog.procyon.org.uk>
 <20080208165240.15902.64781.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008, David Howells wrote:

> +++ b/security/selinux/include/flask.h
> @@ -51,6 +51,7 @@
>  #define SECCLASS_DCCP_SOCKET                             60
>  #define SECCLASS_MEMPROTECT                              61
>  #define SECCLASS_PEER                                    68
> +#define SECCLASS_KERNEL_SERVICE                          69

I just pushed a patch to Linus from Stephen which uses this class number; 
you'll likely need to bump it to 70.


-- 
James Morris
<jmorris@namei.org>
