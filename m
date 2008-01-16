Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbYAPBxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbYAPBxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbYAPBx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:53:26 -0500
Received: from namei.org ([69.55.235.186]:49889 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751440AbYAPBxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:53:25 -0500
Date: Wed, 16 Jan 2008 12:52:22 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: David Howells <dhowells@redhat.com>
cc: sds@tycho.nsa.gov, casey@schaufler-ca.com, Trond.Myklebust@netapp.com,
       npiggin@suse.de, linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 00/26] Permit filesystem local caching
In-Reply-To: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
Message-ID: <Xine.LNX.4.64.0801161248590.24959@us.intercode.com.au>
References: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008, David Howells wrote:

> 
>   (*) 04-keys-get-label.diff
> 
>       A patch to allow the security label of a key to be retrieved.
>       Included because of patches 05-08.
> 
>   (*) 05-security-current-fsugid.diff
>   (*) 06-security-separate-task-bits.diff
>   (*) 07-security-subjective.diff
>   (*) 08-security-secctx2secid.diff
>   (*) 09-security-additional-classes.diff
>   (*) 10-security-kernel_service-class.diff
>   (*) 11-security-kernel-service.diff

All of the security patches look ok to me.  From the SELinux pov, this 
will need to go in after Paul Moore's labeled networking update (hopefully 
very soon after the next merge window opens).


- James
-- 
James Morris
<jmorris@namei.org>
