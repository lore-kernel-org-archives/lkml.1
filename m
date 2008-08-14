Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbYHNQp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbYHNQp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 12:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbYHNQpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 12:45:19 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:42566 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbYHNQpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 12:45:17 -0400
Date: Thu, 14 Aug 2008 09:44:42 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, neilb@suse.de,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 13 (nfsd)
Message-Id: <20080814094442.5a68b2fa.randy.dunlap@oracle.com>
In-Reply-To: <20080814111633.55f5f1e8@surf>
References: <20080813172452.14b0775c.sfr@canb.auug.org.au>
	<20080813104748.13848196.randy.dunlap@oracle.com>
	<20080813180931.GC26765@fieldses.org>
	<20080814111633.55f5f1e8@surf>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2008 11:16:33 +0200 Thomas Petazzoni wrote:

> Le Wed, 13 Aug 2008 14:09:31 -0400,
> "J. Bruce Fields" <bfields@fieldses.org> a écrit :
> 
> > Looks like that's just two more functions that need to be stubbed out
> > in the case where CONFIG_FILE_LOCKING is undefined?--hopefully Thomas
> > Petazzoni (cc'd) could be talked into reproducing this and sending me
> > an incremental fix....
> 
> Here is an incremental fix.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
> 
> Fixup configure out fs locks support
> 
> This patch adds a few more stubs required to get NFS server to compile
> properly with CONFIG_FILE_LOCKING=n.
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> 
> ---
>  include/linux/fs.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linuxdev/include/linux/fs.h
> ===================================================================
> --- linuxdev.orig/include/linux/fs.h
> +++ linuxdev/include/linux/fs.h
> @@ -1050,6 +1050,8 @@
>  #define __break_lease(a, b) ({ 0; })
>  #define lease_get_mtime(a, b) ({ })
>  #define generic_setlease(a, b, c) ({ -EINVAL; })
> +#define vfs_setlease(a, b, c) ({ -EINVAL; })
> +#define lease_modify(a, b) ({ -EINVAL; })
>  #define lock_may_read(a, b, c) ({ 1; })
>  #define lock_may_write(a, b, c) ({ 1; })
>  #endif /* !CONFIG_FILE_LOCKING */
> 
> 
> -- 

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
