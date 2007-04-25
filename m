Return-Path: <linux-kernel-owner+w=401wt.eu-S2992463AbXDYJYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992463AbXDYJYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 05:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992464AbXDYJYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 05:24:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992463AbXDYJYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 05:24:52 -0400
Date: Wed, 25 Apr 2007 11:23:56 +0200
From: Karel Zak <kzak@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [patch 0/8]  mount ownership and unprivileged mount syscall (v4)
Message-ID: <20070425092356.GJ14086@petra.dvoda.cz>
References: <20070420102532.385211890@szeredi.hu> <20070425000414.GH14086@petra.dvoda.cz> <E1Hgblk-00045y-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Hgblk-00045y-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 09:18:28AM +0200, Miklos Szeredi wrote:
> > > The following extra security measures are taken for unprivileged
> > > mounts:
> > > 
> > >  - usermounts are limited by a sysctl tunable
> > >  - force "nosuid,nodev" mount options on the created mount
> > 
> >  The original userspace "user=" solution also implies the "noexec"
> >  option by default (you can override the default by "exec" option).
> 
> Unlike "nosuid" and "nodev", I don't think "noexec" has real security
> benefits.

 Yes. I agree. 

> >  It means the kernel based solution is not fully compatible ;-(
> 
> Oh, I don't think that matters.  For traditional /etc/fstab based user
> mounts, mount(8) will have to remain suid-root, the kernel can't
> replace the fstab check.

 Ok, it makes sense. You're right that for the mount(8) is more
 important the fstab check. 
 
 Please, prepare a mount(8) patch -- with the patch it will be more
 clear.

> We could add a new "nosubmount" or similar flag, to prevent
> submounting, but that again would go against the simplicity of the
> current approach, so I'm not sure it's worth it.

 The "nosubmount" is probably good idea.
 
 The patches seem much better in v4. I'm fun for the feature in the
 kernel (and also for every change that makes mtab more and more
 obsolete :-).

    Karel



> 
> Miklos
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
 Karel Zak  <kzak@redhat.com>
 
 Red Hat Czech s.r.o.
 Purkynova 99/71, 612 45 Brno, Czech Republic
 Reg.id: CZ27690016
