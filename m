Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbYAPNmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbYAPNmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 08:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbYAPNmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 08:42:00 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:19202 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbYAPNl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:41:59 -0500
From: Paul Moore <paul.moore@hp.com>
To: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 08/26] Add a secctx_to_secid() LSM hook to go along with the existing
Date: Wed, 16 Jan 2008 08:41:46 -0500
User-Agent: KMail/1.9.7
Cc: David Howells <dhowells@redhat.com>, sds@tycho.nsa.gov,
       casey@schaufler-ca.com, Trond.Myklebust@netapp.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
References: <20080115234652.22183.24850.stgit@warthog.procyon.org.uk> <20080115234735.22183.36356.stgit@warthog.procyon.org.uk> <Xine.LNX.4.64.0801161204470.24959@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0801161204470.24959@us.intercode.com.au>
Organization: Hewlett Packard
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801160841.46633.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2008 8:05:27 pm James Morris wrote:
> On Tue, 15 Jan 2008, David Howells wrote:
> > secid_to_secctx() LSM hook.  This patch also includes the SELinux
> > implementation for this hook.
> >
> > Signed-off-by: Paul Moore <paul.moore@hp.com>
> > Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
>
> This is useful in its own right, and I would like to push it upstream for
> 2.6.24 unless there are any objections.

Isn't it a bit late in 2.6.24 to add new functionality, especially when there 
isn't an in-tree user for it in 2.6.24?

You are right, there are several users of this function currently under 
development but I'm pretty sure all of them are targeting 2.6.25 or greater.  
With that in mind, I think the prudent thing to is to wait and push this 
upstream for 2.6.25.

-- 
paul moore
linux security @ hp
