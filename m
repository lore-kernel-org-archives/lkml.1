Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbYAOKmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbYAOKmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbYAOKmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:42:07 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56744 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYAOKmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:42:06 -0500
To: serue@us.ibm.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       serue@us.ibm.com, viro@ftp.linux.org.uk, ebiederm@xmission.com,
       kzak@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org
In-reply-to: <20080114233910.GI6704@sergelap.austin.ibm.com>
	(serue@us.ibm.com)
Subject: Re: [patch 9/9] unprivileged mounts: add "no submounts" flag
References: <20080108113502.184459371@szeredi.hu> <20080108113634.382855604@szeredi.hu> <20080114233910.GI6704@sergelap.austin.ibm.com>
Message-Id: <E1JEjEE-0000xZ-RU@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 15 Jan 2008 11:41:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Miklos Szeredi (miklos@szeredi.hu):
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Add a new mount flag "nomnt", which denies submounts for the owner.
> > This would be useful, if we want to support traditional /etc/fstab
> > based user mounts.
> > 
> > In this case mount(8) would still have to be suid-root, to check the
> > mountpoint against the user/users flag in /etc/fstab, but /etc/mtab
> > would no longer be mandatory for storing the actual owner of the
> > mount.
> 
> Ah, I see, so the floppy drive could be mounted as a MNT_NOMNT but
> MNT_USER mount with mnt_owner set.  Makes sense.  I'd ask for a better
> name than 'nomnt', but I can't think of one myself.

Me neither.

Thanks for the review, Serge!

Miklos
