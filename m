Return-Path: <linux-kernel-owner+w=401wt.eu-S1761870AbYEUWx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761870AbYEUWx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759532AbYEUWxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:53:19 -0400
Received: from namei.org ([69.55.235.186]:40239 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757601AbYEUWxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:53:18 -0400
Date: Thu, 22 May 2008 08:52:22 +1000 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Miklos Szeredi <miklos@szeredi.hu>
cc: linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@redhat.com>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [patch 09/14] security: dont pass nameidata to security_inode_permission()
In-Reply-To: <20080521171554.050962936@szeredi.hu>
Message-ID: <Xine.LNX.4.64.0805220852020.8393@us.intercode.com.au>
References: <20080521171458.077908538@szeredi.hu> <20080521171554.050962936@szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008, Miklos Szeredi wrote:

> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Only pass nameidata->flags instead of the nameidata to
> security_inode_permission(), synchronizing it with i_op->permission().
> 
> Currently no security module uses the nameidata parameter.
> 
> The other change in ->permission() is that a dentry is passed instead
> of an inode.  Leave this till AppArmor integration, since that will
> need a struct path instead of an inode.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: James Morris <jmorris@namei.org>
> CC: Stephen Smalley <sds@tycho.nsa.gov>
> CC: Eric Paris <eparis@redhat.com>
> CC: Casey Schaufler <casey@schaufler-ca.com>

Acked-by: James Morris <jmorris@namei.org>



-- 
James Morris
<jmorris@namei.org>
