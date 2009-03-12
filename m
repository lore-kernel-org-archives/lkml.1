Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbZCLQT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbZCLQT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 12:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756352AbZCLQTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 12:19:17 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35333 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbZCLQTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 12:19:16 -0400
Date: Thu, 12 Mar 2009 11:10:47 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Igor Zhbanov <izh1979@gmail.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, neilb@suse.de, Trond.Myklebust@netapp.com,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
Subject: Re: VFS, NFS security bug? Should CAP_MKNOD and
	CAP_LINUX_IMMUTABLE be added to CAP_FS_MASK?
Message-ID: <20090312161047.GA15209@us.ibm.com>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com> <20090311232356.GP13540@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090311232356.GP13540@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting J. Bruce Fields (bfields@fieldses.org):
> On Wed, Mar 11, 2009 at 03:53:34PM +0300, Igor Zhbanov wrote:
> > Hello!
> > 
> > It seems that CAP_MKNOD and CAP_LINUX_IMMUTABLE were forgotten to be
> > added to CAP_FS_MASK_B0 in linux-2.6.x and to CAP_FS_MASK in
> > linux-2.4.x. Both capabilities affects file system and can be
> > considered file system capabilities.
> 
> Sounds right to me--I'd expect rootsquash to guarantee that new device
> nodes can't be created from the network.  Cc'ing random people from the
> git log for include/linux/capability.h in hopes they can help.

Yeah it seems reasonable.  If it is, then does that mean that we
also need CAP_SYS_ADMIN (to write selinux labels) and CAP_SETFCAP
(to set file capabilities) as well?

-serge
